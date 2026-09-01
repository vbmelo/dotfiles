#!/usr/bin/env bash
# Toggle Caveman prose (~/.claude/settings.json outputStyle) together with
# ponytail's lazy-code mode. Caveman governs how we talk, ponytail what we build.
# Usage: caveman-toggle.sh [on|off|toggle|status] [lite|full|ultra]
set -euo pipefail
python3 - "${1:-toggle}" "${2:-full}" <<'PY'
import json, os, pathlib, sys

STYLE = "Caveman"
LEVELS = ("lite", "full", "ultra")

action = sys.argv[1].lower()
level = sys.argv[2].lower()
if level not in LEVELS:
    print(f"unknown level: {level} (use {'|'.join(LEVELS)})", file=sys.stderr)
    raise SystemExit(2)

claude_dir = pathlib.Path(os.environ.get("CLAUDE_CONFIG_DIR", pathlib.Path.home() / ".claude"))
settings = claude_dir / "settings.json"
state = claude_dir / ".ponytail-active"          # live mode, read every prompt
config = pathlib.Path(
    os.environ.get("XDG_CONFIG_HOME", pathlib.Path.home() / ".config")
) / "ponytail" / "config.json"

data = json.loads(settings.read_text()) if settings.exists() else {}
current = data.get("outputStyle")
pony = state.read_text().strip() if state.exists() else None


def read_json(path):
    try:
        return json.loads(path.read_text())
    except Exception:
        return {}


def write_default_mode(mode):
    cfg = read_json(config)
    if not isinstance(cfg, dict):
        cfg = {}
    cfg["defaultMode"] = mode
    config.parent.mkdir(parents=True, exist_ok=True)
    config.write_text(json.dumps(cfg, indent=2) + "\n")


if action == "status":
    print(f"outputStyle: {current or 'default'}")
    print(f"ponytail: {pony or 'off'} (default: {read_json(config).get('defaultMode', 'full')})")
    raise SystemExit(0)
if action == "toggle":
    action = "off" if current == STYLE else "on"
if action not in ("on", "off"):
    print(f"unknown action: {action} (use on|off|toggle|status)", file=sys.stderr)
    raise SystemExit(2)

if action == "on":
    data["outputStyle"] = STYLE
    state.parent.mkdir(parents=True, exist_ok=True)
    state.write_text(level)
    write_default_mode(level)
    new_pony = level
else:
    data.pop("outputStyle", None)
    state.unlink(missing_ok=True)
    write_default_mode("off")
    new_pony = "off"

settings.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
print(f"outputStyle: {current or 'default'} -> {data.get('outputStyle') or 'default'}")
print(f"ponytail: {pony or 'off'} -> {new_pony}")
PY
