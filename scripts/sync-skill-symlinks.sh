#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/sync-skill-symlinks.sh [options]

Create agent-specific skill symlinks from this repo's skills/ directory.

Options:
  --repo PATH     Repo root containing skills/ (default: parent of this script)
  --codex PATH   Codex skills directory (default: ~/.codex/skills)
  --claude PATH  Claude skills directory (default: ~/.claude/skills)
  --pi PATH      Pi agent skills directory (default: ~/.pi/agent/skills)
  --dry-run      Print actions without changing files
  --force        Replace wrong symlinks; never replaces real files/directories
  -h, --help     Show this help

The script is conservative:
  - It links every direct child of skills/ that contains SKILL.md.
  - It leaves existing correct symlinks alone.
  - It refuses to overwrite real files/directories.
  - It skips Codex's .system directory.
EOF
}

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"
codex_dir="$HOME/.codex/skills"
claude_dir="$HOME/.claude/skills"
pi_dir="$HOME/.pi/agent/skills"
dry_run=false
force=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      repo_root="$2"
      shift 2
      ;;
    --codex)
      codex_dir="$2"
      shift 2
      ;;
    --claude)
      claude_dir="$2"
      shift 2
      ;;
    --pi)
      pi_dir="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --force)
      force=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

repo_root="$(cd -- "$repo_root" && pwd)"
skills_dir="$repo_root/skills"

if [[ ! -d "$skills_dir" ]]; then
  echo "Missing skills directory: $skills_dir" >&2
  exit 1
fi

run() {
  if [[ "$dry_run" == true ]]; then
    printf 'DRY RUN:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

link_skill() {
  local source="$1"
  local target_root="$2"
  local name
  local target
  local relative

  name="$(basename -- "$source")"
  target="$target_root/$name"

  run mkdir -p "$target_root"

  if [[ -L "$target" ]]; then
    if [[ "$(readlink -f -- "$target")" == "$(readlink -f -- "$source")" ]]; then
      echo "ok: $target -> $(readlink -- "$target")"
      return
    fi

    if [[ "$force" == true ]]; then
      run rm "$target"
    else
      echo "skip: wrong symlink exists at $target (use --force to replace)" >&2
      return
    fi
  elif [[ -e "$target" ]]; then
    echo "skip: real path exists at $target" >&2
    return
  fi

  relative="$(realpath -m --relative-to="$target_root" "$source")"
  run ln -s "$relative" "$target"
  if [[ "$dry_run" == true ]]; then
    echo "would link: $target -> $relative"
  else
    echo "linked: $target -> $relative"
  fi
}

mapfile -t skill_dirs < <(
  find "$skills_dir" -mindepth 1 -maxdepth 1 -type d -exec test -f '{}/SKILL.md' ';' -print | sort
)

if [[ "${#skill_dirs[@]}" -eq 0 ]]; then
  echo "No skills found under $skills_dir" >&2
  exit 1
fi

for skill in "${skill_dirs[@]}"; do
  link_skill "$skill" "$codex_dir"
  link_skill "$skill" "$claude_dir"
  link_skill "$skill" "$pi_dir"
done

echo "Synced ${#skill_dirs[@]} skills."
