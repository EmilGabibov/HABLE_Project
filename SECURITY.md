# Security policy

## Supported versions

Hable is under active development. Security fixes are applied to the default branch and the latest release when a release line is explicitly published.

## Reporting a vulnerability

Please report suspected vulnerabilities privately through GitHub’s **Report a vulnerability** flow, if enabled for this repository. If that option is unavailable, contact the repository owner through their verified GitHub profile and include `Hable security report` in the subject.

Please include a concise description and impact, the affected commit/version/route/platform, reliable reproduction steps, and sanitized logs or screenshots.

Do not post credentials, tokens, private user data, or an exploitable proof of concept in a public issue.

## Secret handling

Secrets belong in the approved local or deployment secret store. Never commit `.env` files, Cloudflare tokens, email credentials, private keys, or database exports. If a secret is exposed, revoke or rotate it first, then report the incident privately.

