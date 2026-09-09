# Emergency Stash and Context Switching

A working Git classroom demo: leave 20 unfinished lines unstaged, stash them,
switch to main, commit an emergency fix, return to the feature branch, and pop
the stash to restore the exact working state.

## Run on macOS

Open Terminal and run:

```bash
git clone https://github.com/prxneel007/Emergency-Stash-and-Context-Switching.git
cd Emergency-Stash-and-Context-Switching
bash run-demo.sh --interactive
```

Requires Git and Bash. Python is not required for the Git demonstration.
Every run creates a fresh local repository inside a new run-* directory and
pauses at four screenshot checkpoints. It does not reset this cloned repository.
The generated run-* directories are ignored by this outer repository.

## Screenshot checkpoints

| Checkpoint | Capture |
| --- | --- |
| 1 | Feature branch, git diff showing 20 added lines, unstaged changes |
| 2 | git stash list entry and clean main before the emergency fix |
| 3 | Emergency fix commit, clean main, stash still present |
| 4 | git stash pop, empty stash list, restored unstaged changes and matching hashes |

Press Command-Shift-4 to capture each checkpoint, then Enter to continue.

The final output identifies the generated repository and transcript.txt. Open
that generated repository in Terminal to inspect git status, git diff and
git log --all --oneline --decorate --graph.

## Published branches

- main contains the emergency empty-list division fix in app.py.
- feature/expense-summary branches from the baseline before that fix.
- feature.py is a tracked placeholder. The replay adds exactly 20 unfinished
  lines to this file without committing them.

The unfinished function deliberately ends with NotImplementedError.
Ordinary git stash includes it because the placeholder file is already tracked.
Successful git stash pop removes the entry, so the final stash list is empty.
The feature work is checked byte-for-byte and diff-for-diff before and after.

## Evidence and scope

evidence/transcript.txt is actual output from the original local execution.
Its local paths and commit IDs belong to that execution, not to the separately
published GitHub history. Run the script to generate fresh evidence on your Mac.

GitHub stores committed files and branch history. Stashes and uncommitted changes
remain local. The downloadable completed demo ZIP supplied in the chat preserves
the original local repository and restored unfinished workspace.

## Short explanation for the demo

I left 20 lines of an expense-summary feature uncommitted. An urgent bug
interrupted me, so I stashed my work and switched to main. I fixed division by
zero for an empty list, committed it, and confirmed a clean working tree.
I switched back and popped the stash. My feature returned exactly as it was,
with all changes still unstaged.

The replay uses a repository-local Student Demo commit identity and leaves
global Git settings unchanged.
