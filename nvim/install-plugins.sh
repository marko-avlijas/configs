#!/bin/sh
# Install the Neovim plugins from init.lua at the commits in
# nvim-pack-lock.json (vim.pack, built into Neovim >= 0.12). Re-run after
# pulling a change to the lockfile: it also moves installed plugins to the
# locked commits.
set -eu

if ! command -v nvim >/dev/null 2>&1; then
  echo "warning: nvim not found, Neovim plugins not installed" >&2
  exit 0
fi
if [ "$(nvim --clean --headless '+lua io.write(vim.fn.has("nvim-0.12"))' +qa 2>&1)" != 1 ]; then
  echo "warning: nvim is older than 0.12, Neovim plugins not installed" >&2
  exit 0
fi

# Starting nvim installs what is missing (vim.pack.add in init.lua); the
# update moves what is already there to the lockfile's commits.
if ! out=$(nvim --headless \
    "+lua vim.pack.update(nil, { target = 'lockfile', force = true })" \
    +qa 2>&1); then
  echo "$out" >&2
  exit 1
fi

# Show what is on disk; fail if it is not what the lockfile says.
nvim --headless '+lua
  local lock = vim.json.decode(table.concat(vim.fn.readfile(
    vim.fn.stdpath("config") .. "/nvim-pack-lock.json"), "\n")).plugins
  local on_disk, ok = {}, true
  for _, p in ipairs(vim.pack.get(nil, { info = false })) do
    on_disk[p.spec.name] = p.rev
  end
  for name, l in pairs(lock) do
    local rev = on_disk[name]
    io.write(name, " at ", rev or "MISSING", "\n")
    if rev ~= l.rev then
      io.write("error: ", name, " should be at ", l.rev, "\n")
      ok = false
    end
  end
  if not ok then vim.cmd.cquit() end' +qa
