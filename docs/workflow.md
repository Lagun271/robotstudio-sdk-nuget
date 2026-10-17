# Workflow

- **Tasks, bugs, planning:** GitHub Issues. Use issue checklists/comments for status; don't open a
  PR just to record a status update.
- **Delivered work:** merged PRs are the history (`gh pr list --state merged`). Any PR that changes
  user-facing behavior (packed assemblies, pack/push scripts, consume instructions) updates
  `README.md` in the same PR.
- **Branches:** delete the local branch once its PR is merged (`git branch -d <branch>`).
