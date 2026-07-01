#!/usr/bin/env bash
set -euo pipefail

repo_url="${AGENT_SKILLS_REPO_URL:-https://github.com/senorbeast/agent-skills.git}"
install_dir="${AGENT_SKILLS_HOME:-$HOME/.agents}"
branch="${AGENT_SKILLS_BRANCH:-main}"
sync_global_agents="${SYNC_GLOBAL_AGENTS:-1}"

usage() {
  cat <<'EOF'
Usage: install.sh [options]

Install or update the agent-skills repo and sync skill symlinks for Codex,
Claude, and Pi.

Options:
  --dir PATH        Install directory (default: ~/.agents)
  --repo URL        Git repo URL (default: https://github.com/senorbeast/agent-skills.git)
  --branch NAME     Branch to checkout (default: main)
  --no-agents-md    Do not link ~/.codex/AGENTS.md to the repo AGENTS.md
  -h, --help        Show this help

Environment:
  AGENT_SKILLS_HOME       Same as --dir
  AGENT_SKILLS_REPO_URL   Same as --repo
  AGENT_SKILLS_BRANCH     Same as --branch
  SYNC_GLOBAL_AGENTS=0    Same as --no-agents-md
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dir)
      install_dir="$2"
      shift 2
      ;;
    --repo)
      repo_url="$2"
      shift 2
      ;;
    --branch)
      branch="$2"
      shift 2
      ;;
    --no-agents-md)
      sync_global_agents=0
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

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command git
require_command ln
require_command mkdir
require_command realpath

install_dir="${install_dir/#\~/$HOME}"

if [[ -e "$install_dir/.git" ]]; then
  echo "Updating $install_dir"
  git -C "$install_dir" fetch origin "$branch"
  git -C "$install_dir" checkout "$branch"
  git -C "$install_dir" pull --ff-only origin "$branch"
elif [[ -e "$install_dir" ]]; then
  echo "Refusing to clone into existing non-git path: $install_dir" >&2
  echo "Move it aside, or pass --dir to install somewhere else." >&2
  exit 1
else
  echo "Cloning $repo_url into $install_dir"
  git clone --branch "$branch" "$repo_url" "$install_dir"
fi

"$install_dir/scripts/sync-skill-symlinks.sh" --repo "$install_dir"

if [[ "$sync_global_agents" != "0" ]]; then
  mkdir -p "$HOME/.codex"
  source_agents="$install_dir/AGENTS.md"
  target_agents="$HOME/.codex/AGENTS.md"

  if [[ ! -f "$source_agents" ]]; then
    echo "Missing tracked AGENTS.md: $source_agents" >&2
    exit 1
  fi

  if [[ -L "$target_agents" ]]; then
    if [[ "$(readlink -f -- "$target_agents")" == "$(readlink -f -- "$source_agents")" ]]; then
      echo "ok: $target_agents -> $(readlink -- "$target_agents")"
    else
      echo "Replacing wrong AGENTS.md symlink: $target_agents"
      rm "$target_agents"
      ln -s "$(realpath -m --relative-to="$HOME/.codex" "$source_agents")" "$target_agents"
    fi
  elif [[ -e "$target_agents" ]]; then
    backup="$target_agents.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing $target_agents to $backup"
    mv "$target_agents" "$backup"
    ln -s "$(realpath -m --relative-to="$HOME/.codex" "$source_agents")" "$target_agents"
  else
    ln -s "$(realpath -m --relative-to="$HOME/.codex" "$source_agents")" "$target_agents"
  fi
fi

echo "Agent skills setup complete."
