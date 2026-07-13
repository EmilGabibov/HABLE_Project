import { Hono } from 'hono'
import { handle } from 'hono/cloudflare-pages'

type Bindings = {
  DB: D1Database
  JWT_SECRET: string
}

const app = new Hono<{ Bindings: Bindings }>()

async function hashToken(token: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(token);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

function escapeIcsText(text: string): string {
  return text
    .replace(/\\/g, '\\\\')
    .replace(/;/g, '\\;')
    .replace(/,/g, '\\,')
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '')
}

function formatIcsDate(date: Date): string {
  const year = date.getUTCFullYear()
  const month = String(date.getUTCMonth() + 1).padStart(2, '0')
  const day = String(date.getUTCDate()).padStart(2, '0')
  const hours = String(date.getUTCHours()).padStart(2, '0')
  const minutes = String(date.getUTCMinutes()).padStart(2, '0')
  const seconds = String(date.getUTCSeconds()).padStart(2, '0')
  return `${year}${month}${day}T${hours}${minutes}${seconds}Z`
}

app.get('/*', async (c) => {
  const pathname = new URL(c.req.url).pathname
  const tokenMatch = pathname.match(/^\/calendar\/([^/]+)\.ics$/)
  if (!tokenMatch) {
    return c.text('Not Found', 404)
  }

  const tokenParam = decodeURIComponent(tokenMatch[1])

  const tokenRecord = await c.env.DB.prepare(`
    SELECT user_id FROM calendar_feed_tokens
    WHERE token = ? AND revoked_at IS NULL
  `).bind(tokenParam).first<{ user_id: string }>()

  if (!tokenRecord?.user_id) {
    return c.text('Not Found', 404)
  }

  const userId = tokenRecord.user_id

  // Fetch active habits for the user (live progress)
  const { results: habits } = await c.env.DB.prepare(`
    SELECT
      h.id,
      h.title,
      h.target_duration,
      COALESCE(hp.current_duration, 0) as completed_count
    FROM habits h
    LEFT JOIN habit_progress hp ON h.id = hp.habit_id AND hp.user_id = h.user_id
    WHERE h.user_id = ? AND h.status = 'active'
  `).bind(userId).all()

  // Fetch user info for calendar event
  const user = await c.env.DB.prepare(
    'SELECT username FROM users WHERE id = ?'
  ).bind(userId).first<{ username: string }>()

  const username = user?.username || 'Hable User'

  // Generate ICS content
  const now = new Date()
  const prodId = '-//Hable//Hable Calendar//EN'

  let icsContent = 'BEGIN:VCALENDAR\r\n'
  icsContent += 'VERSION:2.0\r\n'
  icsContent += `PRODID:${prodId}\r\n`
  icsContent += 'CALSCALE:GREGORIAN\r\n'
  icsContent += `X-WR-CALNAME:${escapeIcsText(username)}'s Habits\r\n`
  icsContent += 'X-WR-TIMEZONE:UTC\r\n'

  const today = new Date()
  const endDate = new Date(today)
  endDate.setDate(endDate.getDate() + 30)

  for (let d = new Date(today); d <= endDate; d.setDate(d.getDate() + 1)) {
    const dateStr = d.toISOString().split('T')[0]
    const events = habits as Array<{id: string; title: string; target_duration: number; completed_count: number}>

    if (events && events.length > 0) {
      const summary = `${events.map((h: {title: string; completed_count: number; target_duration: number}) => h.title).join(', ')}`
      const description = events
        .map((h: {title: string; completed_count: number; target_duration: number}) => `${h.title}: ${h.completed_count}/${h.target_duration}`)
        .join('\n')

      const uid = `${dateStr}-${userId}@hable.local`
      const dtstamp = formatIcsDate(now)

      icsContent += 'BEGIN:VEVENT\r\n'
      icsContent += `UID:${uid}\r\n`
      icsContent += `DTSTAMP:${dtstamp}\r\n`
      icsContent += `DTSTART;VALUE=DATE:${dateStr.replace(/-/g, '')}\r\n`
      icsContent += `SUMMARY:${escapeIcsText(summary)}\r\n`
      icsContent += `DESCRIPTION:${escapeIcsText(description)}\r\n`
      icsContent += 'STATUS:CONFIRMED\r\n'
      icsContent += 'END:VEVENT\r\n'
    }
  }

  icsContent += 'END:VCALENDAR\r\n'

  return new Response(icsContent, {
    headers: {
      'Content-Type': 'text/calendar; charset=utf-8',
      'Content-Disposition': `attachment; filename="${username}-habits.ics"`,
      'Cache-Control': 'no-store',
    },
  })
})

export const onRequest = handle(app)

