---
description: Turn Caveman prose + ponytail lazy-code mode on, off, or report their state
argument-hint: "[on|off|status] [lite|full|ultra]  (no argument toggles; level defaults to full)"
allowed-tools: Bash(/Users/vb/.claude/caveman-toggle.sh:*)
---

Run exactly this, nothing else:

```
/Users/vb/.claude/caveman-toggle.sh $ARGUMENTS
```

The script drives two paired settings: the Caveman output style (terse prose) and
ponytail's lazy-code mode (YAGNI ladder, stdlib and native features first). The
optional second argument sets the ponytail intensity.

Then report the old and new state of both in one line, and note that the output
style change may need a new session while the ponytail level applies immediately.
Do not read or edit settings.json, the ponytail state file, or the ponytail config
yourself, and do not explain either mode unless asked.
