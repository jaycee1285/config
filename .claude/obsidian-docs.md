# Obsidian Documentation Instructions

> **For Claude:** Follow these instructions when creating or updating documentation for this project.

## Overview

This project's documentation lives in an Obsidian vault at `~/Sync/JMC/SideProjects/`. When you create or update markdown documentation, it should be synced to that location with proper frontmatter for Dataview integration.

---

## Quick Reference

| Item | Path |
|------|------|
| Obsidian vault | `~/Sync/JMC/SideProjects/` |
| Dashboard | `~/Sync/JMC/SideProjects/SideProjects.md` |
| Project template | `~/Sync/JMC/SideProjects/Templates/Project Template.md` |
| This project's folder | `~/Sync/JMC/SideProjects/NixOS-Config/` |

---

## When to Create/Update Docs

Create or update Obsidian documentation when:

1. **New feature added** - Document what it does and how to use it
2. **Significant task completed** - Update the project's `last-completed` field
3. **New tasks identified** - Update the project's `next-tasks` list
4. **Blockers encountered** - Set `blockers` field to describe what's needed
5. **User requests documentation** - Create appropriate reference docs

---

## File Types

### Project Files (type: project)

Main tracking files that appear on the dashboard. One per project.

```yaml
---
type: project
title: "Project Name"
status: active          # active | paused | blocked | completed | archived
priority: 3             # 1 (critical) to 4 (low)
created: 2025-01-28
last-completed: "Description of last completed task"
next-tasks:
  - "First upcoming task"
  - "Second upcoming task"
blockers: "None"        # or describe what's blocking
repo: "https://github.com/user/repo"
tags:
  - sideproject
---

# Project Name

## Overview
Brief description...

## Task Log
### Completed
- [x] Task (date)
```

### Reference Files (type: reference)

Supporting documentation, guides, specs. Linked from project files.

```yaml
---
type: reference
parent: "[[Project Name]]"
created: 2025-01-28
tags:
  - relevant-tag
---

# Document Title

Content...
```

---

## Updating Project Status

When completing work, update the project file's frontmatter:

```yaml
# Before
last-completed: "Old task"
next-tasks:
  - "Task I just finished"
  - "Future task"

# After
last-completed: "Task I just finished"
next-tasks:
  - "Future task"
  - "New task I discovered"
```

### Status Values

| Status | When to Use |
|--------|-------------|
| `active` | Currently being worked on |
| `paused` | On hold, will resume later |
| `blocked` | Waiting on human input or external dependency |
| `completed` | Project finished |
| `archived` | No longer relevant |

### Setting Blockers

When you need human input:

```yaml
status: blocked
blockers: "Need decision on authentication method - OAuth vs JWT"
```

When resolved:

```yaml
status: active
blockers: "None"
```

---

## Creating New Documentation

### Step 1: Determine File Type

- Is this tracking a project? → `type: project`
- Is this supporting docs? → `type: reference`

### Step 2: Choose Location

```
~/Sync/JMC/SideProjects/
├── [ProjectName]/           # Create folder if new project
│   ├── ProjectName.md       # Main project file
│   ├── Feature Docs.md      # Reference files
│   └── Guide.md
```

### Step 3: Add Frontmatter

Always include the YAML frontmatter block at the very top of the file.

### Step 4: Link Related Docs

Use `[[wiki links]]` to connect related documents:

```markdown
See [[Emergency ISO]] for installation instructions.
```

---

## Standard Sections for Project Files

```markdown
# Project Name

## Overview
What this project is and why it exists.

## Goals
- [ ] Primary goal
- [ ] Secondary goal

## Task Log

### Upcoming
- [ ] Next task

### In Progress
- [ ] Current work

### Completed
- [x] Done task (date)

## Quick Reference
Commands, paths, or other frequently needed info.

## Links & Resources
- Repo: url
- Docs: url

## Changelog
| Date | Change |
|------|--------|
| 2025-01-28 | Created |
```

---

## Standard Sections for Reference Files

```markdown
# Document Title

## Overview
What this document covers.

## [Main Content Sections]
...

## Related
- [[Other Doc]]
- [[Project File]]
```

---

## Example: After Completing a Feature

Say you just added a new ISO module. You should:

1. **Update project file** (`NixOS Config.md`):
   ```yaml
   last-completed: "Created Emergency ISO module"
   next-tasks:
     - "Fix flake.nix Sed/Zed mismatch"
     - "Remove duplicate packages"
   ```

2. **Create reference doc** (`Emergency ISO.md`):
   ```yaml
   ---
   type: reference
   parent: "[[NixOS Config]]"
   created: 2025-01-28
   tags:
     - nixos
     - iso
   ---

   # Emergency ISO

   Documentation of the feature...
   ```

3. **Add to Completed in project file**:
   ```markdown
   ### Completed
   - [x] Created Emergency ISO module (2025-01-28)
   ```

---

## Tips

- **Keep frontmatter valid** - Proper YAML syntax, no tabs
- **Update immediately** - Don't batch updates, do them as you complete tasks
- **Be specific** - "Fixed authentication bug in login.ts" not "Fixed bug"
- **Link liberally** - Use `[[wiki links]]` to connect related docs
- **Date your completions** - Add `(YYYY-MM-DD)` to completed tasks

---

## File Naming

- Use Title Case with spaces: `Emergency ISO.md`
- Keep names concise but descriptive
- Match the `title` field in frontmatter

---

## Verification

After creating/updating docs, verify:

1. Frontmatter is at the very top (line 1 is `---`)
2. `type` field is set correctly
3. Project files have all required fields
4. Reference files link back to parent with `[[Project Name]]`
