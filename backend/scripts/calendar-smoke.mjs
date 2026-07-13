import { execSync } from 'child_process';
import http from 'http';
import { spawn } from 'child_process';

async function run() {
  console.log('Setting up DB for calendar smoke test...');
  execSync('npx wrangler d1 execute hable_db --local --command="DELETE FROM calendar_feed_tokens;"', { stdio: 'ignore' });
  execSync('npx wrangler d1 execute hable_db --local --command="DELETE FROM habits;"', { stdio: 'ignore' });
  execSync('npx wrangler d1 execute hable_db --local --command="DELETE FROM habit_progress;"', { stdio: 'ignore' });

  execSync('npx wrangler d1 execute hable_db --local --command="INSERT INTO calendar_feed_tokens (user_id, token, token_hash) VALUES (\'local-user-1\', \'smoke-token\', \'smoke-hash\');"', { stdio: 'ignore' });
  execSync('npx wrangler d1 execute hable_db --local --command="INSERT INTO habits (id, user_id, title, target_duration, status) VALUES (\'habit-1\', \'local-user-1\', \'Smoke Habit 1\', 30, \'active\'), (\'habit-2\', \'local-user-1\', \'Smoke Habit 2\', 60, \'active\');"', { stdio: 'ignore' });
  execSync('npx wrangler d1 execute hable_db --local --command="INSERT INTO habit_progress (user_id, habit_id, current_duration) VALUES (\'local-user-1\', \'habit-1\', 15), (\'local-user-1\', \'habit-2\', 0);"', { stdio: 'ignore' });

  console.log('Starting wrangler dev server...');
  const wrangler = spawn('npx', ['wrangler', 'pages', 'dev', 'public', '--port', '8789'], {
    detached: true,
    stdio: 'ignore'
  });

  // wait a bit for server
  await new Promise(resolve => setTimeout(resolve, 5000));

  console.log('Fetching calendar feed...');
  try {
    const res = await fetch('http://127.0.0.1:8789/calendar/smoke-token.ics');
    const text = await res.text();
    console.log('--- ICS OUTPUT ---');
    console.log(text.substring(0, 500));
    
    if (text.includes('Smoke Habit 1: 15/30\\nSmoke Habit 2: 0/60')) {
      console.log('SUCCESS: description multiline formatting and progress data correct.');
      process.exit(0);
    } else {
      console.error('FAILED: expected description formatting not found in ICS output.');
      process.exit(1);
    }
  } catch (err) {
    console.error('Failed to fetch:', err);
    process.exit(1);
  } finally {
    process.kill(-wrangler.pid);
  }
}

run();
