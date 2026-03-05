# Agent Handoff Protocol

When chaining agents (subagents working in sequence on a task), each agent produces a handoff document for the next. This ensures context isn't lost between agent boundaries.

## Handoff Format

```markdown
## HANDOFF: [source-agent] -> [target-agent]

### Context
What the overall task is and why this handoff is happening.

### Findings
What was discovered, built, or decided. Be specific — file paths, line numbers, test results.

### Files Modified
- `path/to/file.ext` — what changed and why

### Open Questions
Unresolved decisions or ambiguities the next agent needs to address.

### Recommendations
What the next agent should do first, and any risks or constraints to watch for.
```

## When to Use

- Delegating research to a subagent, then acting on findings
- Multi-step refactors where one agent analyzes and another implements
- Any task split across agents where the second depends on the first's output

## Rules

- The handoff document IS the interface — no side channels
- Include enough context that the receiving agent doesn't need to re-read the same files
- List files modified with what changed, not just paths
- Open questions must be specific ("should we use X or Y?"), not vague ("needs more thought")
