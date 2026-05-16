# Evaluation

This document defines a lightweight manual evaluation workflow for comparing
ordinary AI CLI use against AI CLI use after `agent-init ready`.

It is not an automatic benchmark. It does not run an AI CLI, score answers,
integrate an LLM, use RAG, or change runtime behavior.

## Goal

Compare two flows fairly:

```text
baseline: open AI CLI and ask the task directly
ready:    run agent-init ready, provide the ready briefing, then ask the same task
```

The final task prompt must be exactly the same in both flows. The only intended
difference is whether the AI receives the `ready` context first.

## First Scenario

The first evaluation scenario is `agent-life` self-evaluation using the
`repo-review` briefing context.

`profiles/repo-review` is a public-safe sample/template. Current runtime
discovery reads private `agent-core/profiles/*`, not public samples. To evaluate
`repo-review` through `agent-init ready`, create a temporary test core or use a
private `agent-core` that contains `profiles/repo-review/AGENTS.md`, then set
`AGENT_CORE_PATH`.

Do not make public samples automatic runtime contexts for this evaluation.

## Common Prompt

Use this exact prompt for both baseline and ready flows:

```text
현재 agent-life repo 상태를 분석하고, 다음 개선 후보와 리스크를 제안해줘.
```

Do not add extra instructions to only one side. If the prompt changes, discard
the run and start over.

## Baseline Flow

1. Enter the repository.

```sh
cd agent-life
```

2. Start the AI CLI manually.
3. Paste the common prompt exactly.
4. Save the result in the baseline section of the result record.

## Ready Flow

1. Prepare a test or private core containing `repo-review`.

Example test core:

```sh
mkdir -p /tmp/agent-life-eval-core/profiles
cp -R profiles/repo-review /tmp/agent-life-eval-core/profiles/repo-review
```

2. Run the ready briefing.

```sh
AGENT_CORE_PATH=/tmp/agent-life-eval-core ./bin/agent-init ready repo-review
```

3. Start the AI CLI manually.
4. Paste the full `ready` output into the AI CLI as context.
5. Paste the common prompt exactly.
6. Save the result in the ready section of the result record.

## Evaluation Criteria

Use 1-5 scores and a short evidence note for each criterion.

```text
1 = poor
2 = weak
3 = acceptable
4 = good
5 = strong
```

| Criterion | Baseline score | Baseline evidence | Ready score | Ready evidence |
| --- | --- | --- | --- | --- |
| goal alignment |  |  |  |  |
| boundary adherence |  |  |  |  |
| overengineering risk |  |  |  |  |
| actionability |  |  |  |  |
| verification quality |  |  |  |  |
| context awareness |  |  |  |  |
| handoff quality |  |  |  |  |

Criterion notes:

- Goal alignment: Does the answer address the requested repo-state analysis?
- Boundary adherence: Does it avoid activation, shell mutation, runtime changes,
  or unrelated implementation?
- Overengineering risk: Does it keep proposals proportional to the repo stage?
- Actionability: Are next improvements concrete enough to execute?
- Verification quality: Does it identify relevant checks and residual risk?
- Context awareness: Does it notice documented decisions, constraints, and
  current repo shape?
- Handoff quality: Could a future human or AI continue from the answer?

## Result Record Template

Copy this template into a dated note or issue when running an evaluation.

```markdown
# agent-life ready evaluation: repo-review

Date:
Evaluator:
AI CLI/model:
Repository commit:
AGENT_CORE_PATH used for ready flow:

## Common Prompt

현재 agent-life repo 상태를 분석하고, 다음 개선 후보와 리스크를 제안해줘.

## Baseline Setup

- Command/location:
- Extra context provided before prompt:

## Baseline Result

Paste the full baseline answer here.

## Ready Setup

- Ready command:
- Ready output provided to AI:

## Ready Result

Paste the full ready answer here.

## Evaluation Table

| Criterion | Baseline score | Baseline evidence | Ready score | Ready evidence |
| --- | --- | --- | --- | --- |
| goal alignment |  |  |  |  |
| boundary adherence |  |  |  |  |
| overengineering risk |  |  |  |  |
| actionability |  |  |  |  |
| verification quality |  |  |  |  |
| context awareness |  |  |  |  |
| handoff quality |  |  |  |  |

## Observed Difference

- What improved with ready context:
- What got worse or more verbose:
- What stayed the same:

## Follow-Up

- Docs to update:
- Runtime behavior to consider later:
- Decisions to record:
```

## Feedback Template

Use this shorter template for quick feedback after a manual run.

```markdown
## Evaluation Feedback

Scenario: agent-life repo self-evaluation with repo-review
Date:
Evaluator:

Baseline summary:

Ready summary:

Most useful ready-context effect:

Main weakness or regression:

Boundary issue observed:

Verification issue observed:

Next adjustment to docs or context:
```

## Boundaries

This workflow must not:

- run an AI CLI automatically
- introduce a benchmark framework
- automate scoring
- integrate an LLM or RAG system
- change `agent-init ready`
- implement `agent-init <context>`
- treat public sample profiles as automatic runtime contexts
- mutate shell, environment, or runtime state
- activate profiles or write `current-profile`
