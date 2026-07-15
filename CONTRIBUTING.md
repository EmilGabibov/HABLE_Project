# Contributing to Hable

Thanks for helping improve Hable. Small, focused changes are easiest to review and safest to merge.

## Before you start

1. Search existing issues and documentation before opening a new proposal.
2. For product or contract changes, update the relevant files under `Developement/`.
3. Never include secrets, private user data, generated credentials, or production database exports.
4. Keep unrelated local changes out of your branch and pull request.

## Development workflow

```bash
flutter pub get
flutter analyze
flutter test
```

For backend changes:

```bash
cd backend
npm ci
npx tsc --noEmit
```

If code generation is affected, run `flutter pub run build_runner build --delete-conflicting-outputs`. Generated files that are already tracked should be reviewed with the source change; do not hand-edit generated Dart or localization output.

## Pull requests

- Explain the user or system problem and the chosen solution.
- List exact verification commands and any checks you could not run.
- Include screenshots or a short recording for meaningful UI changes.
- Call out schema, API, migration, deployment, or secret changes explicitly.
- Update documentation and tests when behavior or contracts change.

## Commit messages

Use a concise imperative subject, for example: `Fix shared habit completion cancellation`.

## Reporting security issues

Please do not open a public issue for a vulnerability. Follow [SECURITY.md](SECURITY.md).

