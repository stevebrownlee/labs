# AI/LLM Skills Coaching Workshop
**Stepping Stone Labs**
*Curriculum in Progress*

---

## Workshop Overview

A progressive, hands-on curriculum for software developers to build real fluency with AI and LLM tools — from foundational concepts to spec-driven agent development.

**Format:** 1-on-1 and small cohorts
**Audience:** Software developers
**Goal:** Bring participants to the point where they adopt a spec-driven development mindset with AI agents

---

## Curriculum Map

| # | Skill | Description |
|---|-------|-------------|
| 1 | Tokens → Context Window | Understand how LLMs read and process text as tokens, and how the context window defines the boundaries of what a model can "see" at any given time. This is the mental model everything else builds on. |
| 2 | Prompt Engineering | Learn to write clear, structured prompts that reliably produce the output you intend. Focus on instruction clarity, formatting, examples, and understanding how prompt structure shapes model behavior. |
| 3 | Modes / System Prompt | Understand how system prompts set the operating context for a model and how to use them to constrain behavior, define roles, and establish consistent output patterns. |
| 4 | Model Selection | Learn the tradeoffs between reasoning models, fast models, and multimodal models across capability, cost, and latency. Develop the judgment to pick the right model for the right task. |
| 5 | Evaluation | Build the instinct to read LLM output critically — recognizing common failure modes, distinguishing prompt issues from model limitations, and diagnosing *why* something went wrong before reaching for a fix. |
| 6 | Basic Rules | Establish the foundational guardrails that make LLM behavior predictable and production-safe — covering temperature, output formatting, scope constraints, and behavioral boundaries. |
| 7 | AGENTS.md / CLAUDE.md | Learn how to define agent behavior, capabilities, and constraints in a persistent rules file that an agent reads at runtime. Covers the tool-agnostic AGENTS.md standard with a brief look at CLAUDE.md for Claude-specific workflows. |
| 8 | Scoped Rules | Go beyond global rules to define context-specific behavior — restricting or expanding what an agent can do based on the task, directory, or environment it's operating in. |
| 9 | Tool Use / MCP + Function Calling | Understand how models interact with external tools through function calling and the Model Context Protocol. Learn to design, register, and reason about tool use within an agent loop. |
| 10 | Harness Engineering | Build the scaffolding that makes agent workflows testable, observable, and repeatable — including prompt versioning, logging, and treating prompts as code you can diff and roll back. |
| 11 | Writing Specs for Agents | Learn to write precise, unambiguous specifications that an agent can execute reliably. This is the capstone skill — adopting a spec-driven development mindset where clarity of intent drives everything downstream. |

---

## Session Notes

---

### Session 1: Tokens → Context Window

**Format:** 1-on-1 or small cohort | **Duration:** 30 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Explain what a token is and how LLMs consume them
- Understand that every interaction has a real dollar cost they can observe
- Describe the context window as a finite, shared resource that fills from the first message
- Recognize what auto-compaction is, what triggers it, and what it costs

#### Core Foundations
1. **Everything costs money** — tokens are not free, and you can watch them being spent in real time
2. **The context window is a finite resource** — not just conversation history, but everything competing for the same budget from the first message
3. **Modern tools manage that resource for you — but not for free** — auto-compaction and condensing are themselves a cost, and a lossy one

---

#### Session Flow

**[0:00 – 5:00] The Hook — One Question, Surprising Cost**

Open a session inside a project with a real codebase loaded. Send one simple message:

> *"Can you describe the architecture of this project?"*

Immediately surface the token counter and cost display. Don't explain anything yet. Just let the number sit there and ask:

**"I asked one question. Why did that cost that much?"**

Let learners respond. Accept whatever they say. The goal is to surface their current mental model — most will assume the cost is proportional to the length of their message. It isn't. That gap between expectation and reality is what the rest of the session closes.

---

**[5:00 – 10:00] Concept — What Is a Token, and What Does It Cost?**

Cover only what's necessary:

- A token is not a word — it's a chunk of text the model processes. Show a tokenizer (Tiktokenizer works well) with a line of code or a short prompt. Let learners see that whitespace, punctuation, and syntax all cost tokens.
- That first message wasn't just their question — it was the system prompt, tool definitions, any loaded memory files, the codebase context, and their question, all sent together as input.
- Show the token count and the dollar amount side by side. Make the relationship explicit: tokens are the unit, dollars are the consequence.
- Land on the core mental model: **every token in and every token out has a price. You are spending money every time the model reads or writes anything.**

---

**[10:00 – 20:00] The Core Demo — Watching the Budget Drain**

This is the heart of the session. Work across multiple tools to show the same truth from different angles.

**Roo Code / Kilo Code (4 min)**
Continue the conversation from the hook. Ask 3-4 follow-up questions about the codebase — nothing complex, just natural development questions. Watch the visual counter climb with each exchange. Point out:
- Input tokens vs. output tokens cost differently
- Each turn carries the full history forward — the model re-reads everything every time
- The counter never goes down

**Claude Code /context (6 min)**
Switch to Claude Code. Run `/context` after a few exchanges and walk through the breakdown:

```
System prompt:      2.7k tokens   (1.3%)
System tools:      16.8k tokens   (8.4%)
Memory files:       7.4k tokens   (3.7%)
Messages:          12.0k tokens   (6.0%)
Free space:           Xk tokens
Autocompact buffer: 33.0k tokens (16.5%)
```

Make two points explicit:
1. The Messages line is the only part the learner directly controls — everything else is infrastructure overhead
2. The autocompact buffer is already reserved — that space is gone before the conversation starts

Then add an MCP server and run `/context` again. Show the tool definitions consuming a significant chunk instantly. Ask: *"You didn't type anything. Why did the cost just go up?"*

---

**[20:00 – 27:00] Auto-Compaction — The Tool Is Spending Your Money For You**

Demonstrate auto-compaction across tools.

**In Roo Code / Kilo Code:** Run a long enough session that compaction triggers, or show a pre-recorded example where it fires. Show the token count after compaction versus before.

**In Claude Code:** Show `/compact` being run manually. Show what the context looks like before and after.

Make three points:
1. **Compaction costs tokens.** The tool is spending tokens to summarize tokens. It's not free.
2. **Compaction is lossy.** The summary is not the original. Nuance, specific decisions, and exact wording from earlier in the session are gone.
3. **This is the tool protecting you from a hard stop — but it's not the same as managing context deliberately.** Relying on auto-compaction is like relying on your overdraft protection instead of managing your balance.

Close with the principle: **auto-compaction is a safety net, not a strategy.**

---

**[27:00 – 30:00] Close — The Mental Model They're Taking With Them**

Summarize to three statements:

1. Every token costs money. You can watch it happen in real time — and you should.
2. The context window is a shared budget that fills from the first message. Your words are the smallest line item.
3. Modern tools will manage that budget for you automatically — but they do it by spending more tokens and losing fidelity. Deliberate context management will always outperform the safety net.

**Leave them with one action:** In their next AI coding session, open the cost and token display before they start. Watch it for the entire session. Don't change anything yet — just observe.

---

#### Facilitator Notes

- **If running 1-on-1:** After the hook, hand control to the learner. Have them ask the architecture question themselves and read the cost aloud. Ownership of the moment makes it stick.
- **If running a cohort:** Have everyone open their own project and send the same question simultaneously. Compare costs across different codebases — the variation in that first message cost is itself a teaching moment about context size.
- **The moment to watch for:** When a learner sees that their message was the smallest cost in that first exchange. System tools and infrastructure consistently outweigh the user's input. That realization reshapes how they think about every session that follows.
- **Common question:** *"Can't I just use a bigger context window and not worry about this?"* Answer: you can buy more space, and we'll cover model selection in session 4. But a bigger window doesn't change the math — it just delays the conversation about cost and intentionality that you'll eventually have to have anyway.

---

---

### Session 2: Prompt Engineering

**Format:** 1-on-1 or small cohort | **Duration:** 30 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Identify the four core failure modes in a poorly written prompt
- Diagnose *why* a prompt failed before reaching for a fix
- Apply targeted corrections that address the specific failure — not just rewrite the whole thing
- Develop the instinct to read a prompt the way a model reads it, not the way a human reads it

#### The Four Failure Modes
1. **Too vague** — the instruction is underspecified; the model fills the gap with assumptions
2. **Missing context** — the model doesn't have information it needs to do the job correctly
3. **No output format specified** — the model produces the right content in the wrong shape
4. **Assuming knowledge the model doesn't have** — the prompt references something the model can't know from the conversation alone

---

#### Session Flow

**[0:00 – 3:00] Frame the Session**

Open with a single question:

> *"When a prompt doesn't work, what do most people do?"*

Let learners answer. The answer is almost always: rewrite it, try again, add more words, or give up. Then reframe:

> *"That's random. We're going to make it systematic. A prompt fails for a specific reason — and once you can name the reason, the fix is obvious."*

Draw the explicit parallel to debugging: you don't randomly edit code when it breaks. You read the error, identify the cause, and apply a targeted fix. Prompt engineering is the same discipline.

---

**[3:00 – 25:00] The Diagnosis — Four Broken Prompts**

Work through each prompt together. For each one, follow the same three-step pattern:

1. **Read the prompt out loud** — before running it, ask: *"What do you think the model is going to do with this?"*
2. **Run it** — look at the output together
3. **Diagnose together** — *"What went wrong and why?"* Then apply the fix and run it again

---

**Prompt 1 — Too Vague (4 min)**

*Broken:*
```
Improve this function.
```
*(Paste a 20-line JavaScript function with no other context)*

*What happens:* The model guesses what "improve" means — it might add comments, rename variables, refactor logic, or optimize performance. The output is probably fine but almost certainly not what was wanted.

*Diagnosis conversation:*
- "What did the model optimize for?"
- "How would it know what you actually wanted?"
- "What would you have to add to make 'improve' unambiguous?"

*Fixed:*
```
Refactor this function for readability. Rename variables to be 
descriptive, extract any logic that can be a named helper function, 
and add a one-line comment above each logical block. Do not change 
the external behavior.
```

*The lesson:* Vague instructions don't fail — they succeed at the wrong thing. The model always produces output. Your job is to make sure the instruction has only one reasonable interpretation.

---

**Prompt 2 — Missing Context (4 min)**

*Broken:*
```
Write a function that fetches user data and handles errors correctly.
```

*What happens:* The model invents an API shape, picks an HTTP library, chooses an error handling pattern — all from thin air. The output is syntactically correct and completely disconnected from the actual codebase.

*Diagnosis conversation:*
- "What did the model have to assume to answer this?"
- "How many of those assumptions match your project?"
- "What would the model need to see to get this right?"

*Fixed:*
```
Write a function that fetches user data from our existing API client. 
Here is the API client interface:
[paste relevant interface or type definitions]

Use our existing error handling pattern:
[paste example of how errors are handled elsewhere in the codebase]

Match the code style of this existing function:
[paste one example function]
```

*The lesson:* The model doesn't have your codebase in its head. Every assumption it makes is a place your actual requirements could diverge. Context isn't background — it's precision.

---

**Prompt 3 — No Output Format Specified (4 min)**

*Broken:*
```
List the potential security vulnerabilities in this authentication module.
```
*(Paste a 50-line auth module)*

*What happens:* The model produces a well-written narrative paragraph, or a numbered list, or a table, or a mix — depending on whatever it defaults to. The content might be correct but useless if you needed it in a specific format for a ticket, a report, or another prompt.

*Diagnosis conversation:*
- "Is the content wrong, or is the shape wrong?"
- "Where does this output need to go next?"
- "What format would make it immediately usable?"

*Fixed:*
```
List the potential security vulnerabilities in this authentication module.

For each vulnerability, respond in this exact format:
**Vulnerability:** [name]
**Severity:** [Critical / High / Medium / Low]
**Location:** [function or line reference]
**Description:** [one sentence]
**Recommended fix:** [one sentence]
```

*The lesson:* Output format is part of the prompt. If you don't specify the shape, you get whatever shape the model thinks is appropriate — which may be right, or may require you to reprocess the output before it's useful.

---

**Prompt 4 — Assuming Knowledge the Model Doesn't Have (4 min)**

*Broken:*
```
Update this function to follow the new pattern we discussed.
```

*What happens:* The model either guesses at what "the new pattern" means, asks a clarifying question, or produces something confidently wrong based on a pattern it invented.

*Diagnosis conversation:*
- "What does 'the new pattern we discussed' refer to?"
- "Does that exist anywhere in this conversation?"
- "What would the model have to do to answer this correctly?"

*Fixed:*
```
Update this function to follow this pattern:
[paste the pattern explicitly]

Here is the function to update:
[paste the function]
```

*The lesson:* The model only knows what is in the context window right now. References to prior conversations, external documents, verbal agreements, or institutional knowledge are invisible to it. If it isn't in the prompt, it doesn't exist.

---

**[25:00 – 30:00] Close — The Diagnostic Framework**

Summarize the four failure modes as a checklist learners can apply to any prompt before they run it:

| Before you run a prompt, ask: |
|-------------------------------|
| Is my instruction specific enough that it has only one reasonable interpretation? |
| Does the model have all the context it needs to do this correctly? |
| Have I specified the shape of the output I need? |
| Am I referencing anything the model can't see from this conversation? |

Close with the reframe:

> *"A prompt is a specification. The model executes exactly what you wrote — not what you meant. The gap between those two things is where every prompt failure lives."*

**Leave them with one action:** Take the next prompt they write in a real session and run it through this checklist before sending it. Note where it would have failed without the check.

---

#### Facilitator Notes

- **The diagnosis conversation is the session.** Don't rush to the fix. Spend time in the "what went wrong and why" moment — that's where the instinct develops.
- **If running 1-on-1:** Have the learner write the fix themselves after the diagnosis. Don't hand it to them. Their version doesn't have to match the example — the reasoning matters more than the exact wording.
- **If running a cohort:** After each diagnosis, ask the group to write the fix independently before showing the example. Compare approaches — there are multiple valid fixes for each failure mode and seeing the variation reinforces that there's no single right answer, only clearer and less clear prompts.
- **Common reaction:** Learners often want to add everything to every prompt after this session. Watch for over-correction — the goal is precision, not length. A prompt that specifies exactly what's needed is better than a prompt that specifies everything just in case.
- **Connects forward to:** Session 3 (Modes / System Prompt) — once learners understand prompt structure, they're ready to understand how system prompts set a persistent layer of context above every individual prompt.

---

---

### Session 3: Modes / System Prompt

**Format:** 1-on-1 or small cohort | **Duration:** 30 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Explain what a system prompt is and how it differs from a user prompt
- Describe how the system prompt shapes every subsequent interaction in a session
- Identify what makes a system prompt weak or ineffective
- Write a system prompt that produces consistent, reliable behavior from a code writing assistant

---

#### Session Flow

**[0:00 – 3:00] Frame the Session**

Open with a question:

> *"When you open a new chat with an AI tool and start asking it to write code — what is the model's default operating mode?"*

Let learners answer. Most will say something like "general assistant" or "it just tries to help." Then reframe:

> *"Every model has a default mode. And that default was designed for the average user — not for you, not for your stack, not for your standards. The system prompt is how you replace that default with something that works the way you need it to."*

Establish the mental model: the user prompt is what you ask. The system prompt is the context in which every ask is interpreted. It's the difference between asking a random stranger for code and asking a senior engineer on your team who already knows your codebase, your standards, and your constraints.

---

**[3:00 – 22:00] Three Versions — Same Request, Different Reality**

Use the same user message for all three rounds:

```
Write a function that takes a list of user objects and returns 
only the users who have been active in the last 30 days.
```

---

**Version 1 — No System Prompt (5 min)**

Run the user message with no system prompt at all.

*What happens:* The model picks a language (probably Python or JavaScript), invents a data shape for the user object, chooses its own definition of "active," and produces something generic and disconnected from any real codebase.

*Discussion:*
- "Would you use this output directly?"
- "How many assumptions did the model make?"
- "What would you have to change before this was useful?"

*The lesson:* No system prompt means the model operates in default mode. Default mode is optimized for the average request — not yours.

---

**Version 2 — Vague System Prompt (5 min)**

Run the same user message with this system prompt:

```
You are a helpful coding assistant. Write clean, good code.
```

*What happens:* The output is marginally better — maybe slightly cleaner formatting — but the model still invents the language, the data shape, and the logic. "Helpful," "clean," and "good" are not constraints. They're compliments.

*Discussion:*
- "What did this system prompt actually change?"
- "What does 'clean' mean to the model versus what it means to you?"
- "What information is still missing?"

*The lesson:* Vague system prompts create the illusion of control without the reality of it. The model sounds more aligned but is still operating on assumptions.

---

**Version 3 — Learner Writes the System Prompt (9 min)**

Before writing anything, ask the learner:

> *"What would a senior engineer on your team need to know before writing this function? What would you tell them on their first day?"*

Use their answers to drive what goes into the system prompt. Guide them toward covering:

- **Language and framework** — what stack is this for?
- **Code style** — conventions, patterns, naming
- **Data shape assumptions** — what does a user object actually look like?
- **What "active" means** — last login? last API call? last transaction?
- **Output constraints** — typed? documented? tested?
- **What to refuse or flag** — ambiguous requirements, missing context

Have the learner write the system prompt themselves. Then run the same user message against it.

*What happens:* The output is specific, grounded in the actual constraints, and requires far less cleanup before it's useful.

*Discussion:*
- "What changed between version 2 and version 3?"
- "Which assumptions did the model stop making?"
- "What would you add or tighten after seeing this output?"

*The lesson:* A system prompt is a standing brief. The more precisely it reflects how you actually work, the less the model has to guess — and the less you have to fix.

---

**[22:00 – 27:00] The Anatomy of a System Prompt**

Debrief by naming the components the learner naturally included:

| Component | What it does |
|-----------|--------------|
| **Role** | Tells the model who it is and what lens to apply |
| **Stack / environment** | Grounds output in the actual technical context |
| **Constraints** | Defines the boundaries of acceptable output |
| **Output format** | Specifies the shape of the response |
| **Ambiguity handling** | Tells the model what to do when it doesn't have enough information |

Point out that most of these map directly back to the session 2 failure modes — a good system prompt pre-empts the most common prompt failures before the user types anything.

---

**[27:00 – 30:00] Close**

Summarize to three statements:

1. The system prompt is the model's operating reality. Everything the user says is interpreted through it.
2. No system prompt and a vague system prompt produce the same outcome — a model making decisions you didn't authorize.
3. Writing a good system prompt is the same skill as writing a good spec — be precise about role, context, constraints, and output.

**Leave them with one action:** Before their next coding session, write a system prompt for their most common use case. Don't perfect it — just get a first version running and observe what changes.

---

#### Facilitator Notes

- **The "what would you tell a senior engineer on day one" question is the key unlock.** Developers already know how to brief a teammate. The system prompt is that briefing in written form. If a learner gets stuck, come back to this framing.
- **If running 1-on-1:** Let the learner's actual stack drive version 3. The more grounded in their real work, the more the contrast with versions 1 and 2 lands.
- **If running a cohort:** Have each learner write their own version 3 for their own stack. Run them all and compare outputs — the variation shows how much the system prompt shapes behavior.
- **Common question:** *"Should I write a new system prompt for every task?"* Answer: not necessarily. A well-written system prompt for a code writing assistant covers most of your daily work. You layer specifics in the user prompt. Session 8 (Scoped Rules) covers when and how to scope rules more narrowly.
- **Connects forward to:** Session 6 (Basic Rules) — system prompts are where basic rules live. Once learners understand what a system prompt does, they're ready to learn what rules belong in it and why.

---

---

### Session 4: Model Selection

**Format:** 1-on-1 or small cohort | **Duration:** 30 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Describe the tradeoffs between Claude Haiku, Sonnet, and Opus across capability, cost, and latency
- Explain what extended thinking is and when it's worth the cost
- Match a task type to the right model based on complexity, latency, and budget requirements
- Develop the judgment to stop defaulting to the most capable model for every task

#### The Four Configurations

| Configuration | What it represents |
|---|---|
| **Claude Haiku** | Fast, cheap, high volume — optimized for speed and cost |
| **Claude Sonnet** | Balanced — strong capability at reasonable cost |
| **Claude Opus** | Maximum capability — highest cost, slower |
| **Claude Opus + Extended Thinking** | Reasoning mode — deliberate, deep, most expensive |

---

#### Session Flow

**[0:00 – 3:00] Frame the Session**

Open with a question:

> *"When you open Claude and start a task — which model do you reach for?"*

Most learners default to the most capable model available. Then reframe:

> *"Defaulting to the best model for every task is like driving a Formula 1 car to the grocery store. It works. But it costs more, it's slower to get started, and it's overkill for what you actually needed. Model selection is a design decision — and the wrong choice in either direction has real consequences."*

Establish the two failure modes:
- **Underpowered:** using Haiku for a task that needs deep reasoning — fast, cheap, wrong
- **Overpowered:** using Opus for a task Sonnet handles fine — slower, unnecessary cost, no better output

---

**[3:00 – 22:00] The Comparison — Same Task, Four Configurations**

Use this prompt for all four rounds:

```
This codebase has a React frontend, a Node.js API layer, and a 
PostgreSQL database. We are experiencing performance degradation 
under load — response times spike above 2 seconds at around 500 
concurrent users. Analyze the likely architectural causes and 
recommend a prioritized remediation plan.
```

For each run: note the response time, show the cost, read the output quality together.

---

**Run 1 — Claude Haiku (4 min)**

*What happens:* Response is fast — likely under 3 seconds. Cost is minimal. The output identifies some surface-level causes (missing indexes, N+1 queries, lack of caching) but stays generic. It won't synthesize across the full stack or surface non-obvious bottlenecks.

*Discussion:*
- "How fast was that?"
- "What did it miss?"
- "What type of task would this output be good enough for?"

*The lesson:* Haiku is right when you need speed, volume, or a first pass. It's wrong when the task requires synthesizing complexity across multiple layers.

---

**Run 2 — Claude Sonnet (4 min)**

*What happens:* Noticeably more structured output. Sonnet identifies cross-layer interactions — connection pool exhaustion, ORM query inefficiency hitting the database, React re-renders causing API request storms. The remediation plan is prioritized and actionable. Cost is moderate. Latency is reasonable.

*Discussion:*
- "What did Sonnet see that Haiku missed?"
- "Would you trust this output enough to act on it?"
- "Is there anything you'd want to go deeper on?"

*The lesson:* Sonnet is the right default for most serious development tasks. It handles complexity without the cost and latency of Opus.

---

**Run 3 — Claude Opus (4 min)**

*What happens:* The output is deeper — Opus may surface architectural patterns, suggest specific tooling (connection poolers, query analyzers, caching layers), and reason about tradeoffs between remediation options. Cost is significantly higher. Latency is slower.

*Discussion:*
- "What did Opus add over Sonnet?"
- "Was the delta worth the cost difference?"
- "What would have to be true about this task for Opus to be the right call?"

*The lesson:* Opus is right when the stakes are high, the problem is genuinely complex, and you need the model to reason across many variables simultaneously. It's wrong as a default.

---

**Run 4 — Claude Opus + Extended Thinking (4 min)**

Enable extended thinking and run the same prompt.

*What happens:* The model visibly deliberates before responding. The output may include reasoning chains, explicit consideration of alternatives, and more confident prioritization. Cost is highest. Latency is longest. The thinking tokens themselves are visible and billable.

*Discussion:*
- "What did extended thinking change about the output?"
- "What did it cost compared to the previous three runs?"
- "When would you actually reach for this?"

*The lesson:* Extended thinking is a reasoning mode, not a quality mode. It's most valuable when the problem has genuine ambiguity, multiple competing solutions, or requires the model to hold many constraints simultaneously. For most tasks it's unnecessary overhead.

---

**[22:00 – 27:00] The Decision Framework**

Debrief by building a decision framework together from what learners just observed:

| If the task is... | Reach for... |
|---|---|
| High volume, simple, latency-sensitive | Haiku |
| Standard development work, moderate complexity | Sonnet |
| High-stakes, genuinely complex, cross-system reasoning | Opus |
| Ambiguous, multi-constraint, needs deliberate reasoning | Opus + Extended Thinking |

Then add the cost axis: pull up the live API pricing for each configuration and calculate what 1,000 requests would cost at each tier. Make the dollar difference concrete — not to alarm learners, but to make model selection feel like a real engineering decision with a real cost attached.

---

**[27:00 – 30:00] Close**

Summarize to three statements:

1. Every model in the Claude family solves the same class of problems — the difference is depth, cost, and latency. Matching those tradeoffs to the task is the skill.
2. Defaulting to Opus for everything is not a strategy — it's a habit. Haiku and Sonnet handle the majority of real development work.
3. Extended thinking is a tool for genuine reasoning complexity, not a quality upgrade. Know when the problem actually needs it.

**Leave them with one action:** For the next week, before starting any AI session, name the model they're using and why. Not to change anything yet — just to make the choice conscious instead of automatic.

---

#### Facilitator Notes

- **The cost reveal in the debrief is the anchor.** Seeing what 1,000 requests costs at Haiku vs. Opus makes the abstract concrete. Learners who build agents at scale will feel this acutely.
- **If running 1-on-1:** Have the learner narrate what they notice after each run before you say anything. Their observations surface their current mental model and give you something to build on.
- **If running a cohort:** Assign one configuration to each learner or pair, have them run it and report back. The debrief becomes a collective synthesis rather than a coach-led walkthrough.
- **Extended thinking note:** Pricing and availability for extended thinking may shift. Check current Anthropic pricing before the session and adjust the cost comparison accordingly.
- **Common question:** *"Should I always use the cheapest model that works?"* Answer: cost is one dimension, not the only one. A wrong answer from Haiku on a high-stakes architectural decision costs more than the price difference between Haiku and Opus. Match the model to the stakes, not just the budget.
- **Connects forward to:** Session 5 (Evaluation) — now that learners can see output quality differences across models, they need a framework for evaluating whether any given output is actually good enough to act on.

---

---

### Session 5: Evaluation

**Format:** 1-on-1 or small cohort | **Duration:** 30 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Apply a three-point review protocol to any LLM-generated output
- Identify SID violations, pattern deviations, and over-engineering in realistic code output
- Develop the instinct to read LLM output critically before acting on it

#### The Review Protocol
Every piece of LLM output gets evaluated against three questions, in order:

1. **SID** — Are Single Responsibility, Interface Segregation, and Dependency Inversion applied?
2. **Patterns** — Did the model adhere to the architectural and code style patterns already established in the project?
3. **Simplicity** — Did the model reach for complexity where a simpler solution would have worked?

---

#### The Purpose-Built Output

**The prompt that generated the output:**
```
We have a FastAPI application. Write an endpoint that accepts a 
user ID, fetches the user's order history from the database, 
filters to orders placed in the last 90 days, and returns the 
results as JSON.
```

**Established project patterns (share this context with the learner):**
- Repository pattern is used for all database access
- Services are thin — they orchestrate, they don't query
- Pydantic models are defined in a dedicated `schemas/` module
- Endpoints return a standard response envelope: `{"data": ..., "error": null}`
- Dependencies are injected via FastAPI's `Depends()`

**The LLM output to evaluate:**
```python
from fastapi import FastAPI
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from datetime import datetime, timedelta
from typing import Optional, List
import json

app = FastAPI()

DATABASE_URL = "postgresql://user:password@localhost/db"
engine = create_engine(DATABASE_URL)

class OrderService:
    def __init__(self):
        self.db_session = Session(engine)
        self.cache = {}
        self.cache_ttl = {}
        self.cache_duration = 300

    def get_recent_orders(
        self, 
        user_id: int, 
        days: int = 90,
        include_cancelled: bool = True,
        include_refunded: bool = True,
        sort_by: str = "created_at",
        sort_order: str = "desc",
        page: int = 1,
        page_size: int = 50
    ):
        cache_key = f"{user_id}_{days}_{include_cancelled}_{sort_by}_{page}"
        
        if cache_key in self.cache:
            if datetime.now().timestamp() - self.cache_ttl[cache_key] < self.cache_duration:
                return self.cache[cache_key]

        cutoff_date = datetime.now() - timedelta(days=days)
        
        query = self.db_session.query(Order)
        query = query.filter(Order.user_id == user_id)
        query = query.filter(Order.created_at >= cutoff_date)
        
        if not include_cancelled:
            query = query.filter(Order.status != "cancelled")
        if not include_refunded:
            query = query.filter(Order.status != "refunded")
            
        if sort_order == "desc":
            query = query.order_by(getattr(Order, sort_by).desc())
        else:
            query = query.order_by(getattr(Order, sort_by))

        total = query.count()
        orders = query.offset((page - 1) * page_size).limit(page_size).all()
        
        result = {
            "orders": [o.__dict__ for o in orders],
            "total": total,
            "page": page,
            "page_size": page_size
        }
        
        self.cache[cache_key] = result
        self.cache_ttl[cache_key] = datetime.now().timestamp()
        
        return result

order_service = OrderService()

@app.get("/users/{user_id}/orders")
async def get_user_orders(user_id: int):
    try:
        result = order_service.get_recent_orders(user_id)
        return result
    except Exception as e:
        return {"error": str(e)}
```

---

#### Session Flow

**[0:00 – 3:00] Frame the Session**

Open by introducing the review protocol — SID, Patterns, Simplicity — and explain the exercise:

> *"You asked an AI to write an endpoint. This is what it gave you. Before you do anything else, read it. You have 5 minutes. Find what's wrong."*

Hand them the established project patterns alongside the output. Don't hint at what to look for or how many problems there are. Let them read.

---

**[3:00 – 10:00] Solo Review**

Learner reads independently. Coach stays silent.

If running a cohort, have everyone review individually and write down their findings before any discussion. The solo attempt matters — it surfaces each learner's current instincts before the group shapes them.

---

**[10:00 – 25:00] The Three-Strike Debrief**

Work through the protocol in order. For each strike, ask the learner what they found before revealing the answer.

---

**Strike 1 — SID (5 min)**

*What's wrong:*
- **Single Responsibility:** `OrderService` is doing too much — it owns database access, caching logic, query building, filtering, sorting, and pagination all in one class. Each of those is a separate responsibility.
- **Interface Segregation:** The `get_recent_orders` method has accumulated parameters that serve different callers — `include_cancelled`, `include_refunded`, `sort_by`, `page_size` — turning a simple fetch into a general-purpose query engine the endpoint never asked for.
- **Dependency Inversion:** `OrderService` instantiates its own `Session(engine)` directly. It depends on a concrete implementation, not an abstraction. This makes it untestable and tightly coupled to the database engine.

*Discussion:*
- "Which of these would you have caught in a normal code review?"
- "Which one would have slipped through?"
- "What does the model optimizing for flexibility instead of correctness tell you about how it interprets an underspecified prompt?"

---

**Strike 2 — Patterns (5 min)**

*What's wrong:*
- The project uses a **repository pattern** for database access. The model queried the database directly inside the service — bypassing the pattern entirely.
- **Services are thin** in this project — they orchestrate, they don't query. This service queries, filters, sorts, paginates, and caches. It's a repository, a service, and a cache layer rolled into one.
- **Pydantic schemas** belong in `schemas/`. The model returned raw `__dict__` serialization of SQLAlchemy objects instead — which leaks internal model structure and bypasses validation.
- The **response envelope** is `{"data": ..., "error": null}`. The model returned a completely different shape — and the error handler returns `{"error": str(e)}` with no `data` key.
- **Dependencies are injected via `Depends()`**. The model instantiated `order_service` as a module-level global instead.

*Discussion:*
- "The model had no way of knowing these patterns existed. Whose fault is this?"
- "What would you have needed to include in the prompt to get output that matched your project?"
- "This connects directly back to session 2 — which failure mode does this represent?"

*(Answer: Missing context — the model didn't have the project patterns available when it generated the output.)*

---

**Strike 3 — Simplicity (5 min)**

*What's wrong:*
- The prompt asked for one thing: fetch orders for a user, filter to the last 90 days, return as JSON. The model built a general-purpose order query engine with pagination, sorting, cancellation filtering, refund filtering, and an in-memory cache — none of which were asked for.
- The in-memory cache on a module-level singleton is particularly problematic — it will silently serve stale data across requests in a multi-worker deployment and has no invalidation strategy.
- The model optimized for a hypothetical future where this endpoint needs to do more. That future doesn't exist yet. The prompt was simple. The output should have been too.

*Discussion:*
- "Where did the model get the idea that pagination and sorting were needed?"
- "What's the cost of shipping this over the simpler version?"
- "YAGNI is a principle your team already applies to code. How do you apply it to evaluating LLM output?"

---

**[25:00 – 30:00] Close — The Protocol as a Habit**

Summarize the three strikes and what each revealed:

1. **SID** caught structural problems that would have created technical debt and testing friction
2. **Patterns** caught the disconnect between the output and the actual codebase — a missing context problem that traces back to the prompt
3. **Simplicity** caught the model solving a problem that wasn't asked — a failure mode that's invisible if you're only checking whether the code runs

Close with the reframe:

> *"The model didn't write bad code. It wrote reasonable code for an underspecified prompt with no project context. The review protocol isn't about catching the model making mistakes — it's about catching the gap between what you asked and what you actually needed."*

**Leave them with one action:** Apply this protocol to the next piece of LLM-generated code they would normally just skim and ship. Write down which strike, if any, it fails — and why.

---

#### Facilitator Notes

- **The solo review period is non-negotiable.** The learner's unprompted findings reveal their current instincts. If they find Strike 3 but miss Strike 1, that tells you exactly where to spend time in the debrief.
- **Strike 2 is the most important connection to earlier sessions.** The pattern violations are entirely a prompting failure — the model couldn't follow patterns it wasn't shown. This is the moment to tie session 2 and session 3 forward: a better prompt with project context in the system prompt would have prevented most of Strike 2.
- **If running a cohort:** After the solo review, have learners share their findings before the debrief. The variation in what different people caught is itself a teaching moment about the subjectivity of code review and why a structured protocol matters.
- **Common reaction:** Learners often want to blame the model after this session. Redirect: the model did exactly what it was asked. The protocol exists to catch what the prompt didn't specify.
- **Connects forward to:** Session 6 (Basic Rules) — the pattern violations in Strike 2 are exactly the kind of thing that belongs in a system prompt as a standing rule. Once learners can evaluate output against project standards, they're ready to encode those standards as rules the model follows by default.

---

---

### Session 6: Basic Rules

**Format:** 1-on-1 or small cohort | **Duration:** 60 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Distinguish between rules that actually change model behavior and rules that only sound correct
- Identify the properties of a well-written rule: specific, consequential, and testable
- Write rules that directly address the failure modes they identified in session 5
- Assemble a working set of basic rules they can use immediately in their system prompt

---

#### Session Flow

**[0:00 – 5:00] Frame the Session**

Open with a question:

> *"If you could give the model one standing instruction it would follow in every session — what would it be?"*

Let learners answer. Most will produce something vague — "write good code," "follow best practices," "be concise." Accept the answers without judgment, then reframe:

> *"Those are intentions, not rules. A rule changes what the model does. An intention just describes what you want. The difference is specificity — and we're going to build that instinct today."*

Introduce the three properties of a well-written rule:
- **Specific** — unambiguous enough that two different models would interpret it the same way
- **Consequential** — it changes the output in a meaningful, observable way
- **Testable** — you can run a prompt and verify whether the rule was followed

---

**[5:00 – 30:00] Part 1 — Good Rule vs. Bad Rule**

Present the following 10 rules. Work through each one together — coach and learner reading and sorting in real time.

For each rule, ask: *"Is this specific, consequential, and testable — or does it fail one of those?"*

**The 10 Rules:**

1. `Write clean, readable code.`
2. `Never instantiate dependencies inside a class. Always accept them as constructor parameters.`
3. `Be helpful and accurate.`
4. `All functions must have a single responsibility. If a function does more than one thing, split it.`
5. `Write good error handling.`
6. `Never return raw SQLAlchemy model instances from a service. Always serialize through a Pydantic schema.`
7. `Always use best practices.`
8. `If a requirement is ambiguous, stop and ask a clarifying question before writing any code.`
9. `Never add features, parameters, or capabilities that were not explicitly requested.`
10. `Try to write efficient code.`

**The Verdicts:**

| Rule | Verdict | Why |
|---|---|---|
| 1. Write clean, readable code | ❌ Bad | "Clean" and "readable" are subjective. The model can't fail this rule because it means nothing specific. |
| 2. Never instantiate dependencies inside a class | ✅ Good | Specific, testable, directly observable in the output. |
| 3. Be helpful and accurate | ❌ Bad | This is the model's default behavior. It adds nothing. |
| 4. All functions must have a single responsibility | ✅ Good | Specific and testable — you can read the output and verify it. |
| 5. Write good error handling | ❌ Bad | "Good" is undefined. The model will comply and produce whatever it considers good. |
| 6. Never return raw SQLAlchemy model instances | ✅ Good | Extremely specific, directly consequential, immediately testable. |
| 7. Always use best practices | ❌ Bad | Completely unenforceable — "best practices" means something different in every context. |
| 8. Stop and ask if a requirement is ambiguous | ✅ Good | Specific behavior (stop, ask), testable (does it ask or does it guess?). |
| 9. Never add features not explicitly requested | ✅ Good | Directly addresses the simplicity failure from session 5. Specific and testable. |
| 10. Try to write efficient code | ❌ Bad | "Try" is not a constraint. "Efficient" is undefined. This rule cannot be violated. |

*Debrief questions after sorting:*
- "What do the five bad rules have in common?"
- "Which of the good rules would have prevented the failures we found in session 5?"
- "What would you have to add to rule 5 to make it a good rule?"

*(On rule 5 — a good version might be: "All exceptions must be caught at the service boundary. Never let exceptions propagate to the endpoint layer unhandled. Log the full stack trace and return a structured error response.")*

---

**[30:00 – 55:00] Part 2 — Rules From Failures**

Return to the session 5 FastAPI output. For each of the three strikes, have the learner write one or two rules that would have prevented it. Coach guides but learner writes.

---

**Strike 1 — SID Violations → Rules**

*Learner writes rules. Coach guides toward:*

```
Never instantiate database sessions directly inside a service class. 
Accept them as injected dependencies via FastAPI's Depends().

All service methods must orchestrate — they call repositories and 
other services. They do not contain query logic.

A class that handles more than one of the following is too large and 
must be split: querying, caching, filtering, pagination, serialization.
```

*Discussion:*
- "Are these specific enough that the model can't wriggle out of them?"
- "Can you test each one by reading the output?"

---

**Strike 2 — Pattern Violations → Rules**

*Learner writes rules. Coach guides toward:*

```
All database access must go through a repository class. Services 
never query the database directly.

All response schemas must be defined in the schemas/ module as 
Pydantic models. Never serialize SQLAlchemy objects directly.

All endpoints must return the standard response envelope: 
{"data": <result>, "error": null} on success and 
{"data": null, "error": "<message>"} on failure.

All service dependencies must be injected via FastAPI's Depends() 
mechanism. Never instantiate services as module-level globals.
```

*Discussion:*
- "These rules encode your project patterns. Where do they live?"
- "If they live in the system prompt, what happens when you open a new session without the system prompt?"

*(This plants the seed for session 7 — AGENTS.md is where these rules live persistently.)*

---

**Strike 3 — Simplicity Violations → Rules**

*Learner writes rules. Coach guides toward:*

```
Never add parameters, options, or features that were not explicitly 
requested in the prompt. If you think something might be needed, 
ask — do not implement it speculatively.

Never implement caching unless explicitly instructed to do so.

Implement the simplest solution that correctly satisfies the 
stated requirements. Do not optimize for hypothetical future 
requirements.
```

*Discussion:*
- "How does this rule interact with rule 8 from Part 1 — stop and ask if something is ambiguous?"
- "Is there tension between being helpful and following this rule?"

---

**[55:00 – 60:00] Close**

Collect all the rules the learner wrote in Part 2 into a single list. Read them back together.

> *"This is the beginning of your rulebook. Every rule here came from a real failure — which means every rule here has a consequence attached to it. That's what makes it a rule and not an intention."*

Summarize to three statements:

1. A rule that can't be violated isn't a rule — it's a preference. Rules must be specific, consequential, and testable.
2. Bad rules don't constrain the model — they just describe what you hope it does. The model will comply and produce whatever it considers to match the description.
3. The best rules come from failures. If you haven't seen the output that violates the rule, you don't know if the rule actually works.

**Leave them with one action:** Add the rules from Part 2 to their system prompt before their next coding session. Run the session 5 prompt again with the rules in place and compare the output.

---

#### Facilitator Notes

- **Part 1 moves fast — keep the sorting conversation tight.** The goal is pattern recognition, not deep analysis of every rule. Spend most of the time on the bad rules that are closest to things learners would actually write.
- **The pivot from Part 1 to Part 2 is the session's key moment.** Part 1 builds the judgment. Part 2 applies it immediately to failures they already understand. The connection should be explicit: *"Now that you know what a good rule looks like — write the rules that would have caught what we found last session."*
- **If running a cohort:** In Part 2, assign one strike to each learner or pair. Have them write their rules independently, then share and compare. Different learners will write rules at different levels of specificity — the comparison sharpens everyone's instincts.
- **The planted seed at the end of Strike 2 is intentional.** The question "where do these rules live?" is meant to surface the gap that session 7 closes. Don't answer it fully — just let the question sit.
- **Common reaction:** Learners often want to write very long, comprehensive rules. Watch for over-specification — a rule that tries to cover every edge case becomes unreadable and the model starts to ignore it. One clear constraint per rule is stronger than one rule that tries to do five things.
- **Connects forward to:** Session 7 (AGENTS.md / CLAUDE.md) — the rules built in this session need a permanent home. Right now they live in a system prompt the learner has to remember to paste. AGENTS.md is the answer to that problem.

---

---

### Session 7: AGENTS.md / CLAUDE.md

**Format:** 1-on-1 or small cohort | **Duration:** 60 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Explain what AGENTS.md is and why it exists
- Identify the key sections of a well-structured AGENTS.md and what each one does
- Adapt an existing AGENTS.md to their own project context
- Extend their AGENTS.md beyond the example with rules specific to their stack and workflow
- Understand where CLAUDE.md fits as a Claude-specific implementation of the same concept

---

#### The Example AGENTS.md

Share this file with learners at the start of the walkthrough section:

```markdown
# Project Agent Rules

## Identity and Role
You are a senior software engineer working on this codebase.
Your job is to write production-quality code that matches the
existing patterns, standards, and architecture of this project.
You are not a general-purpose assistant — you are a contributor
to this specific project.

## Stack
- Language: Python 3.11+
- Framework: FastAPI
- ORM: SQLAlchemy 2.0
- Validation: Pydantic v2
- Database: PostgreSQL
- Testing: pytest with pytest-asyncio
- Package manager: Poetry

## Architecture Rules
- All database access goes through a repository class in `repositories/`
- Services in `services/` orchestrate only — they call repositories,
  they do not contain query logic
- All Pydantic schemas live in `schemas/` — never define them inline
- All endpoints return the standard response envelope:
  {"data": <result>, "error": null} on success
  {"data": null, "error": "<message>"} on failure
- Dependencies are injected via FastAPI's Depends() — never
  instantiate services or repositories as module-level globals

## Code Quality Rules
- Every function has a single responsibility. If it does more than
  one thing, split it.
- Never instantiate dependencies inside a class. Accept them as
  constructor parameters.
- Never return raw SQLAlchemy model instances from a service.
  Always serialize through a Pydantic schema.
- All exceptions are caught at the service boundary. Never let
  exceptions propagate to the endpoint layer unhandled.

## Simplicity Rules
- Implement the simplest solution that correctly satisfies the
  stated requirements.
- Never add parameters, options, or features not explicitly requested.
- Never implement caching, pagination, or sorting unless explicitly
  instructed.
- If a requirement is ambiguous, stop and ask before writing code.

## Output Rules
- Never explain what you are about to do — just do it.
- Do not add comments unless the logic is genuinely non-obvious.
- Do not include example usage unless asked.
- When modifying existing code, show only the changed sections
  unless asked for the full file.

## What to Refuse
- Requests to bypass the repository pattern
- Requests to add speculative features
- Requests that would introduce a second source of truth for
  data that already has one
- Any instruction that contradicts the architecture rules above —
  flag the conflict and ask for clarification instead of complying
```

---

#### Session Flow

**[0:00 – 5:00] Frame the Session**

Open by picking up the thread from session 6:

> *"Last session you built a set of rules. You put them in a system prompt. What happens to those rules when you close the session?"*

They disappear. Every new session starts from zero. The learner has to remember to paste them back in — and in the real world, they won't always remember, the paste will be incomplete, or a teammate opens a session without them entirely.

> *"AGENTS.md solves this. It's a file that lives in your project. The agent reads it automatically at the start of every session. Your rules aren't something you have to remember to bring — they're part of the project."*

Establish the mental model: AGENTS.md is to agent behavior what a linter config is to code style. It's not manual, it's not optional, and it's not personal — it's part of the project.

---

**[5:00 – 30:00] Walkthrough — Anatomy of a Real AGENTS.md**

Share the example file. Walk through each section together. For each section, explain what it does, why it's structured the way it is, and what would break if it were missing.

**Identity and Role (3 min)**

> *"Why does the agent need to know it's a senior engineer on this specific project?"*

Without this, the model operates as a general-purpose assistant. It optimizes for the average request. The identity section replaces the default with something specific — the model now interprets every request through the lens of a contributor to this codebase, not a stranger trying to help.

Point out: this is the system prompt from session 3, made permanent and project-scoped.

**Stack (2 min)**

> *"Why list the stack explicitly when the model can probably infer it from the code?"*

Inference is probabilistic. A rule is deterministic. Listing the stack explicitly eliminates the model reaching for the wrong library version, using a deprecated pattern, or defaulting to a different ORM because it appeared more often in training data. This section costs almost nothing to write and eliminates an entire class of subtle errors.

**Architecture Rules (5 min)**

> *"Where did these rules come from?"*

They came from session 6 — Strike 2, pattern violations. These are the rules that encode how this project is structured. Point out that each rule is specific and testable — you can read any output and verify whether the repository pattern was followed, whether schemas are in the right place, whether the response envelope is correct.

Ask the learner: *"If a new engineer joined your team, where would these rules currently live?"* Probably nowhere explicit — in someone's head, in a README nobody reads, or in code review feedback after the fact. AGENTS.md makes them explicit, persistent, and machine-readable.

**Code Quality Rules (4 min)**

> *"These look familiar — where did they come from?"*

Session 6, Part 2 — Strike 1, SID violations. These are the rules the learner wrote to prevent the dependency injection failure, the single responsibility violation, the SQLAlchemy serialization leak. Walk through each one and connect it back to the specific failure it prevents.

**Simplicity Rules (3 min)**

Session 6, Strike 3. The model built a pagination engine nobody asked for. These rules prevent that. Point out rule 4 in this section specifically:

```
If a requirement is ambiguous, stop and ask before writing code.
```

This is the rule that forces clarification instead of speculation. It's one of the highest-leverage rules in the file because it catches problems before they're implemented rather than after.

**Output Rules (3 min)**

> *"These rules aren't about code quality — what are they about?"*

They're about how the model communicates, not what it produces. A model that explains everything before doing it burns context and slows the session. A model that adds comments to obvious code clutters the output. A model that shows the full file when you asked it to change one function wastes your review time.

These rules tune the communication style to match how an experienced developer actually wants to work with an agent.

**What to Refuse (2 min)**

> *"Why does the agent need explicit refusal rules?"*

Because without them, the model will comply with any instruction — including ones that contradict the architecture rules above. The refusal section tells the model that some requests are not things it should do even if asked, and what to do instead of complying: flag the conflict and ask for clarification.

This is the first introduction to the concept of agent constraints — a theme that will deepen significantly in sessions 8 and 9.

---

**[30:00 – 50:00] Build — Adapt Then Extend**

**Part A — Adapt (10 min)**

Have the learner take the example AGENTS.md and adapt it to their own project. They keep the structure but replace the content:

- Swap the stack section for their actual stack
- Replace architecture rules with the patterns their project actually uses
- Bring in the rules they wrote in session 6, Part 2

Coach reviews each section as it's written. Push back on anything vague — if a rule wouldn't pass the session 6 test (specific, consequential, testable), it doesn't go in the file.

**Part B — Extend (10 min)**

Now go beyond the example. Ask the learner:

> *"What does the model do wrong in your project that isn't covered by these sections?"*

Common extensions learners add at this stage:
- Testing rules (every new function gets a test, tests live in `tests/` mirroring the source structure)
- Git rules (commit messages follow conventional commits, never commit directly to main)
- Documentation rules (public functions get docstrings, internal functions don't)
- Workflow rules (always run the test suite before marking a task complete)
- Tool-specific rules (specific MCP servers to use or avoid for certain tasks)

Have the learner write at least two sections that aren't in the example. These sections represent the institutional knowledge that exists only in their head right now — AGENTS.md is where it belongs.

---

**[50:00 – 58:00] The CLAUDE.md Detour**

Brief but important. Open CLAUDE.md documentation alongside the learner's completed AGENTS.md.

> *"AGENTS.md is the tool-agnostic standard. CLAUDE.md is Claude Code's implementation of the same concept. The structure is similar — the differences are in Claude-specific features."*

Cover the key differences:
- CLAUDE.md supports Claude-specific directives (memory, extended thinking preferences, tool permissions)
- CLAUDE.md can be scoped to subdirectories — a concept we'll develop fully in session 8
- CLAUDE.md is read by Claude Code automatically; AGENTS.md is read by Kilo Code and other tool-agnostic agents
- The rules you write are identical — only the file name and a few Claude-specific sections differ

> *"If you're working in a Claude Code environment, use CLAUDE.md. If you're working in Kilo Code or a tool-agnostic setup, use AGENTS.md. If you're on a team using both, you can maintain both files — the rules section is identical."*

---

**[58:00 – 60:00] Close**

Summarize to three statements:

1. AGENTS.md is where your rules live permanently. It's not a system prompt you remember to paste — it's part of the project, version-controlled, and read automatically.
2. A good AGENTS.md encodes three things: who the agent is, how the project is structured, and what the agent is not allowed to do.
3. The rules in your AGENTS.md should come from real failures. If a rule doesn't connect to a consequence you've seen, it probably doesn't need to be there.

**Leave them with one action:** Commit their AGENTS.md to their project repository before the next session. It's not done — it never will be — but it needs to be in version control and running before session 8.

---

#### Facilitator Notes

- **The connection back to sessions 5 and 6 is the backbone of this session.** Every section of the example AGENTS.md should trace back to something the learner already encountered — don't let the walkthrough feel like new material. It's the same material, now organized and persistent.
- **The adapt-then-extend structure matters.** Adapting first gives learners a scaffold and builds confidence. Extending forces them to go beyond the example and surface knowledge that only exists in their head — which is where the highest-value rules come from.
- **If running a cohort:** Have learners adapt individually, then share their extensions with the group. The variety of extensions reveals what each person considers non-obvious enough to encode — and the group often surfaces rules others hadn't thought of.
- **The CLAUDE.md detour should stay brief.** The goal is awareness, not depth. Learners who work in Claude Code environments will naturally migrate — don't spend time on it beyond what's needed to orient them.
- **Common question:** *"How long should AGENTS.md be?"* Answer: long enough to encode your real constraints, short enough that the model reads the whole thing without the rules section dominating the context window. Revisit session 1 — every line of AGENTS.md costs tokens on every request.
- **Connects forward to:** Session 8 (Scoped Rules) — AGENTS.md at the project root sets global behavior. But some directories, tasks, or workflows need different rules. Scoped rules are the answer to "what if I need different behavior in different parts of the project?"

---

---

### Session 8: Scoped Rules

**Format:** 1-on-1 or small cohort | **Duration:** 60 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Distinguish between rules that belong globally in AGENTS.md and rules that only apply in a specific context
- Structure a rule file with a description, scope glob, and rule content
- Build a routing table in AGENTS.md that points the agent to the right rule files
- Produce a complete scoped rule system from their existing AGENTS.md

---

#### The Pattern

**AGENTS.md (global + router):**
```markdown
# Project Agent Rules

## Identity and Role
...global identity rules...

## Global Rules
...rules that apply everywhere...

## Rule Files
The following rule files contain context-specific rules. Load the
relevant files based on the files you are currently working with.

| File | Description | When to load |
|------|-------------|--------------|
| docs/rules/python.md | Idiomatic Python rules | Any .py file |
| docs/rules/orm.md | SQLAlchemy and repository rules | repositories/, models/ |
| docs/rules/api.md | FastAPI endpoint and schema rules | routers/, schemas/ |
| docs/rules/testing.md | pytest conventions and patterns | tests/ |
```

**docs/rules/python.md (scoped rule file):**
```markdown
description: Idiomatic Python rules
scope: /api/**/*
---

...rules...
```

---

#### Session Flow

**[0:00 – 5:00] Frame the Session**

Open by returning to the AGENTS.md the learner built in session 7:

> *"This file works. But imagine this project grows — a frontend gets added, an infrastructure layer, a data pipeline. Every new context brings new rules. Where do they go?"*

Let learners answer. They'll either say "add them to AGENTS.md" or sense that something breaks down at scale. Then surface the two problems with a monolithic AGENTS.md:

1. **Context cost** — every rule loads on every request, even when it's irrelevant. An ORM rule fires when the agent is editing a GitHub Actions workflow. That's wasted tokens and diluted attention.
2. **Maintainability** — a single file that governs everything becomes hard to reason about, hard to update, and hard to version meaningfully.

> *"The solution is to make AGENTS.md a router. It holds the rules that are truly global, and it points the agent to the right rule files for everything else. The agent loads only what's relevant to the current task."*

Introduce the two-part structure: the routing table in AGENTS.md and the scoped rule files in `docs/rules/`.

---

**[5:00 – 30:00] The Decomposition — Sort Every Rule**

Open the learner's AGENTS.md from session 7. Work through it section by section together, asking for each rule:

> *"Is this rule relevant everywhere, or only in a specific context?"*

Sort every rule into one of five buckets in real time:

| Bucket | Stays in... |
|---|---|
| Truly global | AGENTS.md global rules section |
| Python-specific | `docs/rules/python.md` |
| ORM / database | `docs/rules/orm.md` |
| API / endpoint | `docs/rules/api.md` |
| Testing | `docs/rules/testing.md` |

**How to run the sorting conversation:**

For each rule, the coach asks and the learner decides:

*"Never instantiate dependencies inside a class."*
- Is this Python-specific or language-agnostic? → Python-specific → `python.md`

*"All database access goes through a repository class."*
- Is this an ORM concern or an architecture concern? → ORM and architecture → `orm.md`, but also worth a lighter version in global rules as an architectural principle

*"If a requirement is ambiguous, stop and ask before writing code."*
- Does this apply everywhere or just in certain contexts? → Everywhere → stays in AGENTS.md

*"Never return raw SQLAlchemy model instances from a service."*
- SQLAlchemy-specific → `orm.md`

*"All endpoints return the standard response envelope."*
- FastAPI-specific → `api.md`

*"Every function has a single responsibility."*
- Language-agnostic, applies everywhere → stays in AGENTS.md

**What learners discover during sorting:**

- Some rules they thought were global are actually stack-specific
- Some rules belong in two places — a high-level principle in AGENTS.md and a specific implementation rule in a scoped file
- Some sections of AGENTS.md collapse significantly when context-specific rules are extracted
- A few rules surface that need new rule files they hadn't planned for

By the end of the sort, AGENTS.md should be noticeably leaner — identity, truly global rules, and a routing table stub.

---

**[30:00 – 52:00] Build — Rule Files and Routing Table**

**Part A — Write the rule files (15 min)**

Have the learner create `docs/rules/` and write at least two rule files from the sorted buckets. Coach guides structure, learner writes content.

Each rule file follows this structure:

```markdown
description: <one line describing what this file governs>
scope: <glob pattern for when to load this file>
---

## Rules

- Rule 1
- Rule 2
- Rule 3
```

**Example — `docs/rules/orm.md`:**
```markdown
description: SQLAlchemy ORM and repository pattern rules
scope: /api/repositories/**/* /api/models/**/*
---

## Rules

- All database access goes through a repository class in `repositories/`.
  Never query the database directly from a service.
- Never return raw SQLAlchemy model instances from a service.
  Always serialize through a Pydantic schema defined in `schemas/`.
- Repository methods accept a SQLAlchemy session as an injected
  dependency. Never instantiate sessions inside a repository.
- Never use lazy loading. Always use explicit eager loading with
  joinedload() or selectinload() for related objects.
- All repository methods are async. Never use synchronous SQLAlchemy
  calls in an async context.
```

**Example — `docs/rules/api.md`:**
```markdown
description: FastAPI endpoint and schema rules
scope: /api/routers/**/* /api/schemas/**/*
---

## Rules

- All endpoints return the standard response envelope:
  {"data": <result>, "error": null} on success
  {"data": null, "error": "<message>"} on failure
- All request and response schemas are defined in `schemas/`.
  Never define Pydantic models inline in a router file.
- Dependencies are injected via FastAPI's Depends() mechanism.
  Never instantiate services or repositories directly in an endpoint.
- Endpoint functions contain no business logic. They validate input,
  call a service, and return the result.
- All endpoints have a response_model declared explicitly.
```

Coach reviews each rule file as it's written. Push back on anything that wouldn't pass the session 6 test — specific, consequential, testable.

**Part B — Build the routing table (7 min)**

Now rebuild AGENTS.md. The global rules section should be significantly leaner than the session 7 version. Add the routing table pointing to the rule files just created:

```markdown
## Rule Files
The following rule files contain context-specific rules. Load the
relevant files based on the files you are currently working with.

| File | Description | When to load |
|------|-------------|--------------|
| docs/rules/python.md | Idiomatic Python rules | Any .py file |
| docs/rules/orm.md | SQLAlchemy and repository rules | repositories/, models/ |
| docs/rules/api.md | FastAPI endpoint and schema rules | routers/, schemas/ |
| docs/rules/testing.md | pytest conventions and patterns | tests/ |
```

Then run a test. Give the agent a task that touches a `repositories/` file. Verify it loads `orm.md`. Give it a task that touches a `routers/` file. Verify it loads `api.md`. Give it a task that touches a `tests/` file — point out that `testing.md` doesn't exist yet, which is the learner's homework.

---

**[52:00 – 58:00] The Token Connection**

Return to session 1 explicitly:

> *"Remember the first session — everything in context costs tokens. Every rule file that doesn't load is tokens you don't spend."*

Show the `/context` breakdown with the full monolithic AGENTS.md loaded versus the lean AGENTS.md with only the relevant rule file loaded. The difference in the rules section of the context breakdown makes the token benefit visible and concrete.

Then make the second point:

> *"A model with 20 relevant rules pays closer attention to each one than a model with 80 rules where 60 don't apply. Scoping isn't just about cost — it's about signal quality."*

---

**[58:00 – 60:00] Close**

Summarize to three statements:

1. AGENTS.md is a router, not a monolith. Global rules stay global — everything else gets scoped to where it's actually relevant.
2. A scoped rule file is self-describing: its description tells the agent what it governs, its scope tells the agent when to load it, and its rules tell the agent what to do.
3. Scoping is a token management strategy as much as an organization strategy. Rules that don't load don't cost anything — and rules that do load carry more weight when they're not competing with irrelevant ones.

**Leave them with one action:** Write `docs/rules/testing.md` before the next session. Apply the same structure — description, scope glob, specific rules. Commit it alongside the rule files built today.

---

#### Facilitator Notes

- **The sorting conversation is the most valuable part of the session.** Don't rush it. The decisions learners make about what's truly global versus context-specific reveal how they think about the boundaries of their codebase — and the disagreements are where the learning happens.
- **Watch for rules that belong in two places.** The distinction between a high-level architectural principle (global) and its specific implementation constraint (scoped) is subtle but important. When a rule wants to live in both places, that's a signal to write two versions: a principle in AGENTS.md and a concrete rule in the scoped file.
- **The test at the end of Part B is non-negotiable.** Learners need to see the routing actually working — not just trust that it does. The moment the agent loads `orm.md` for a repository task and doesn't load it for a router task is when the pattern becomes real.
- **If running a cohort:** Have each learner own one rule file — one writes `orm.md`, one writes `api.md`, one writes `python.md`. Share and review each other's files before building the routing table. The cross-review surfaces inconsistencies in how different people write rules.
- **Common question:** *"What if a task touches files in multiple scopes?"* Answer: the agent loads all relevant rule files. If a task touches both `repositories/` and `routers/`, both `orm.md` and `api.md` load. The rules don't conflict — they govern different layers of the same task.
- **Connects forward to:** Session 9 (Tool Use / MCP + Function Calling) — rule files can specify which tools the agent should or shouldn't use in a given context. Once learners understand scoped rules, they're ready to scope tool access the same way.

---

---

### Session 9: Tool Use / MCP + Function Calling

**Format:** 1-on-1 or small cohort | **Duration:** 60 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Explain what MCP is and how tool definitions load into the context window
- Describe the tool call loop — how a model decides to call a tool, what it sends, and how the result feeds back into context
- Design a multi-tool chain that connects GitHub and Slack through an agent
- Identify the failure points in a tool chain and reason about how to handle them
- Understand the token cost of tool definitions and how to manage it

---

#### The Tool Chain

**Task:** Review a pull request, post structured comments directly on the PR, and notify the team in Slack when the review is complete.

**Tools required:**
- **GitHub MCP** — read PR diff, post review comments
- **Slack MCP** — send notification to a channel when review is done

**The agent prompt:**
```
Review the open pull request #47. Apply our standard code review 
criteria. Post inline comments on the PR for each issue found. 
When the review is complete, send a summary to the #code-reviews 
Slack channel with the PR title, number of issues found, and 
a link to the PR.
```

---

#### Session Flow

**[0:00 – 8:00] Frame — What Is a Tool Call, Really?**

Before touching any configuration, establish the mental model.

Open a Claude session with no tools active. Ask it to review a pull request. It will either refuse, ask for the diff to be pasted in, or hallucinate a review. Then ask:

> *"Why can't the model just go get the PR itself?"*

Let learners answer. Then explain:

> *"The model is a text processor. It reads tokens and produces tokens. It has no ability to reach outside its context window on its own. A tool is a bridge — it's a function the model can request be called on its behalf. The result comes back as tokens, which the model then reads and acts on."*

Draw the tool call loop explicitly:

```
1. Model reads the prompt and decides a tool call is needed
2. Model outputs a structured tool call request (function name + parameters)
3. The tool executes outside the model
4. The result is injected back into the context window as a new message
5. Model reads the result and decides what to do next
6. Repeat until the task is complete
```

Make two points before moving on:
- **The model never executes the tool.** It only requests that it be called. Something else — the agent framework, the MCP server — actually runs it.
- **Every tool result costs tokens.** The result is injected into the context window just like any other message. A tool that returns a large payload can consume significant context budget in a single call.

---

**[8:00 – 20:00] MCP Configuration — Coach Configures, Learner Observes**

Coach configures GitHub MCP and Slack MCP while narrating every decision. Learner observes and asks questions.

**What to narrate during configuration:**

**Step 1 — Install and register the MCP servers**

Point out:
- Each MCP server is a process that runs alongside the agent
- The agent communicates with it over a defined protocol
- The server exposes a set of tools — each tool has a name, a description, and a parameter schema

**Step 2 — Show what the tool definitions look like**

Before running anything, run `/context` in Claude Code or show the tool definitions panel in Kilo Code. Show the learner what just loaded into the context window:

```
github_list_pull_requests: List open pull requests in a repository
  - owner: string (required)
  - repo: string (required)
  - state: string (optional, default: "open")

github_get_pull_request: Get details and diff for a specific PR
  - owner: string (required)
  - repo: string (required)
  - pull_number: integer (required)

github_create_review_comment: Post an inline comment on a PR
  - owner: string (required)
  - repo: string (required)
  - pull_number: integer (required)
  - body: string (required)
  - path: string (required)
  - line: integer (required)

slack_post_message: Post a message to a Slack channel
  - channel: string (required)
  - text: string (required)
```

Ask the learner:
> *"These tool definitions are in your context window right now. What does that mean for your token budget?"*

Connect back to session 1 — tool definitions load before the conversation starts, just like system prompts and memory files. A five-server MCP setup can consume 50,000+ tokens before a single message is sent.

**Step 3 — Connect back to scoped rules**

Point out that this is exactly what session 8's scoped rules can govern:

```markdown
## Rule Files
| File | Description | When to load |
| docs/rules/github.md | GitHub tool usage rules | Any PR or issue task |
| docs/rules/slack.md | Slack notification rules | Any notification task |
```

The agent loads GitHub tool rules only when working on a PR task — and with them, specific guidance about which GitHub tools to use, in what order, and with what parameters.

---

**[20:00 – 42:00] Build and Run the Tool Chain**

**Part A — Design the chain before running it (7 min)**

Before running the prompt, have the learner map the tool chain:

> *"Walk me through every tool call this agent will need to make, in order, to complete this task."*

Expected answer:
1. `github_get_pull_request` — fetch the PR diff
2. `github_create_review_comment` × N — post one comment per issue found
3. `slack_post_message` — send the summary notification

Ask:
- "What information does step 3 need that comes from step 2?"
- "What happens if step 2 finds no issues — does step 3 still run?"
- "What does the agent need to track across all these calls?"

This surfaces the statefulness problem: the agent needs to accumulate the issues found across multiple review comment calls before it can write the Slack summary. That state lives in the context window — each tool result adds to it.

**Part B — Run the chain (15 min)**

Run the agent prompt. Watch each tool call happen in sequence. Narrate what's happening at each step:

- When `github_get_pull_request` fires: *"The model decided it needs the diff before it can review anything. It's requesting the tool call."*
- When the result returns: *"The diff is now in the context window. The model is reading it."*
- When `github_create_review_comment` fires for the first time: *"The model found its first issue. It's requesting a comment be posted."*
- After all comments are posted: *"The model now has a record of every comment it posted in context. It's using that to write the Slack summary."*
- When `slack_post_message` fires: *"Final step. The model is closing the loop."*

Run `/context` after the chain completes. Show the learner what the context window looks like now — the original prompt, every tool call request, every tool result, and the final response. Make the token cost of a multi-step tool chain visible.

**Part C — Break it deliberately (8 min)**

Now introduce a failure. Modify the Slack MCP configuration so the channel name is wrong. Run the chain again.

*What happens:* GitHub tool calls succeed. The Slack call fails with an error. The error is injected into the context window as a tool result. Show learners what the agent does with it — does it retry, ask for clarification, or give up?

*Discussion:*
- "The agent got halfway through the task before it failed. What's the state of the world right now?"
- "The PR comments were already posted. Is that a problem?"
- "What would a well-designed rule in your AGENTS.md say about how to handle partial failures in a tool chain?"

Guide toward: *"Before starting a multi-step tool chain that has side effects, verify that all required tools are reachable."* This is a rule that belongs in a `docs/rules/tooling.md` scoped rule file.

---

**[42:00 – 55:00] Tool Chain Design Principles**

Debrief by extracting the principles that emerged from building and breaking the chain:

**1. Design the chain before you run it**
Map every tool call, its inputs, its outputs, and what downstream steps depend on it. If you can't describe the chain before running it, the agent can't execute it reliably.

**2. Tool results accumulate in context**
Every tool result is a message in the context window. A chain with 10 tool calls and large payloads can fill a significant portion of the context budget before the task is done. Design chains with the context cost in mind.

**3. Side effects are irreversible**
PR comments and Slack messages can't be unsent. In any chain with irreversible side effects, verify prerequisites before acting. Read-only tool calls should always come before write tool calls.

**4. Partial failure is the hardest failure mode**
A chain that fails at step 7 of 10 has already done 6 things. The agent needs explicit guidance on what to do — retry, roll back where possible, notify the user, or halt. Without that guidance it will improvise — and improvisation is unpredictable.

**5. Tool definitions cost tokens before the conversation starts**
Load only the MCP servers you need for the current task. A rule file that governs when to activate which servers is a token management strategy as much as an organizational one.

---

**[55:00 – 60:00] Close**

Summarize to three statements:

1. A tool call is a request, not an action. The model asks for the tool to be called — the framework runs it and returns the result as tokens. The model never touches the outside world directly.
2. Multi-step tool chains are design problems. Map the chain, identify the dependencies, understand the side effects, and plan for partial failure before you run anything.
3. Tool definitions load into the context window before the conversation starts. Every MCP server you connect has a token cost. Load only what the current task needs.

**Leave them with one action:** Write `docs/rules/tooling.md` — a scoped rule file that governs how the agent should behave when using tools. Include at minimum: verify tool reachability before starting a chain, read before writing, and explicit guidance on what to do when a tool call fails.

---

#### Facilitator Notes

- **The tool call loop diagram is the most important concept in the session.** Return to it whenever learners seem confused about what the model is doing — everything else is an application of that loop.
- **The deliberate failure in Part C is non-negotiable.** Learners who only see the happy path leave thinking tool chains are easy. The failure surfaces the partial completion problem, which is the most important design constraint in agentic tool use.
- **If running a cohort:** Have one learner track token usage throughout Part B using `/context` after each tool call. Have another track which tool calls fire and in what order. Debrief both observations together — the token accumulation and the execution sequence are equally important.
- **Common question:** *"Can the agent use tools in parallel?"* Answer: some frameworks support parallel tool calls, but the default is sequential. Parallel tool use introduces its own complexity around result ordering and context management — flag it as an advanced topic for the advanced workshop.
- **Common question:** *"What if the model calls the wrong tool?"* Answer: tool selection is driven by the tool's name and description — which is why well-named, clearly described tools are a design concern, not just a configuration concern. A tool called `send_message` is more ambiguous than one called `slack_post_message`. The description is what the model reads to decide whether to call it.
- **Connects forward to:** Session 10 (Harness Engineering) — once learners can design and run tool chains, they need the scaffolding to make those chains testable, observable, and repeatable. Harness Engineering is the answer to "how do I know this tool chain works consistently?"

---

---

### Session 10: Harness Engineering

**Format:** 1-on-1 or small cohort | **Duration:** 60 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Define harness engineering and explain why it represents a paradigm shift in how engineers work
- Describe the three pillars of a well-built harness: context engineering, architectural constraints, and garbage collection
- Apply the core loop: when the agent makes a mistake, engineer the fix so it never makes that mistake again
- Audit their own repository for harness readiness and identify the highest-leverage improvements

---

#### The Framing

Harness engineering is the discipline of building everything *around* the model so it can do reliable work without constant supervision. The horse is the AI model — powerful and fast, but it doesn't know where to go on its own. The harness — rules, constraints, documentation, feedback loops — is what makes that raw power useful and directed.

Mitchell Hashimoto: *"It is the idea that anytime you find an agent makes a mistake, you take the time to engineer a solution such that the agent never makes that mistake again."*

---

#### Session Flow

**[0:00 – 8:00] Frame — The Paradigm Shift**

Open with a provocation:

> *"In every session so far, when something went wrong, what did you do?"*

Learners will say: fix the prompt, adjust the rules, rerun it. Then reframe:

> *"That's the right instinct — but most teams stop there. They fix the instance. Harness engineering means fixing the class. Every mistake the agent makes is a signal that something in the environment is missing, ambiguous, or unenforced. Your job isn't to correct the agent — it's to make the mistake structurally impossible."*

Introduce the paradigm shift with three statements:

1. **The agent sees only the repository.** Knowledge that lives in Google Docs, chat threads, or people's heads is not accessible to the system. If it isn't in the repo, it doesn't exist for the agent. The Slack thread where your team aligned on an architectural pattern? If it's not in a file the agent can read, it might as well have never happened.

2. **The human's job changes.** The engineer's job moves from writing code to designing environments, specifying intent clearly enough for agents to act on, and building feedback loops that catch mistakes mechanically. When something fails, the fix is almost never "try harder" — it's "what capability is missing, and how do we make it legible and enforceable?"

3. **Constraints make agents better, not worse.** A model given a vague prompt produces vague output. A model given precise constraints produces reliable output. Harness engineering extends this principle from the prompt to the entire working environment.

---

**[8:00 – 45:00] The Three Pillars**

---

**Pillar 1 — Context Engineering (15 min)**

> *"What does the agent know, and how does it find what it needs?"*

Start with the failure mode: the monolithic AGENTS.md. OpenAI tried the "one big AGENTS.md" approach and it failed in predictable ways: context is a scarce resource, a giant instruction file crowds out the task and the code, too much guidance becomes non-guidance, it rots instantly, and it's hard to verify.

Connect this directly to what learners built in sessions 7 and 8 — they already solved this problem. The routing table in AGENTS.md pointing to scoped rule files in `docs/rules/` is exactly the pattern OpenAI converged on: a short AGENTS.md serving primarily as a map, with pointers to deeper sources of truth elsewhere.

Now extend the concept beyond rule files. A fully harness-engineered repository has:

- **Design documentation** — catalogued, indexed, with verification status. Not a wiki — a set of files in `docs/` that are version-controlled alongside the code they describe.
- **Architecture maps** — diagrams and documents that show domain boundaries, package layering, and dependency flow. The agent uses these to understand where code belongs.
- **Quality documents** — a graded view of each product area, tracking gaps and known technical debt. The agent knows not just what exists but how good it is.
- **Execution plans** — ephemeral lightweight plans for small changes, and execution plans with progress and decision logs checked into the repository for complex work. Active plans, completed plans, and known technical debt are all versioned and co-located.

Ask the learner: *"Right now, if an agent opened your repository with no other context, what could it learn about how your project works?"*

That gap — between what's in the repo and what's in people's heads — is the harness work.

---

**Pillar 2 — Architectural Constraints (15 min)**

> *"What can the agent not do — and is that enforced mechanically or just stated?"*

This is where harness engineering most clearly diverges from prompt engineering. A rule that says "don't violate module boundaries" will eventually be forgotten. A linter that fails the CI when a boundary is crossed cannot be forgotten.

OpenAI enforces architectural boundaries and dependency layers across domains through mechanical rules and structural tests. Dependencies flow in a controlled sequence from Types → Config → Repo → Service → Runtime → UI, with agents restricted to operate within these layers.

Draw the analogy explicitly: this is a type system for architecture. You don't ask the developer to "please only pass integers" — the compiler refuses to compile if they don't. Custom linters and structural tests play the same role for agents.

The SWE-agent research gives this academic grounding. The paper introduces the Agent-Computer Interface (ACI) — the idea that LM agents need interfaces designed for their specific strengths and weaknesses. Four ACI design principles map directly to constraint engineering:

1. **Actions should be simple** — don't give agents complex commands. Give them purpose-built tools with clear names and behaviors.
2. **Actions should be compact** — consolidate multi-step operations. An edit command that replaces the sequence of read, modify, write, verify is better than exposing all four steps separately.
3. **Feedback should be informative but concise** — after editing a file, immediately show the agent what changed. Don't make it ask.
4. **Guardrails mitigate error propagation** — a syntax checker that automatically blocks bad edits prevents cascading failures. Without linting guardrails, agent performance dropped measurably.

Ask the learner: *"In your project right now, what architectural rules exist only as documentation versus rules that are mechanically enforced?"*

Everything in the first category is a harness gap. The homework from session 6 — writing rules that are specific, consequential, and testable — was preparation for this moment. Testable rules can become automated checks.

---

**Pillar 3 — Garbage Collection (7 min)**

> *"How does the harness stay accurate as the codebase evolves?"*

Agent-generated code accumulates a different kind of drift than human-written code. Docs go stale. Architecture maps diverge from reality. Rules that were written for one version of the codebase no longer apply. The OpenAI team ran periodic "garbage collection" agents to find inconsistencies and violations — documentation for agents, by agents.

Think of this as a linter for repository coherence: are the docs still accurate? Do the architecture maps match reality? Are there constraint violations that slipped through?

This doesn't require a sophisticated setup. A simple approach:
- A periodic agent task: *"Review `docs/` and identify any documentation that contradicts the current codebase. Open a PR with corrections."*
- A CI check that validates AGENTS.md links resolve to real files
- A weekly review of the quality document — does the grade still reflect reality?

The key insight: every AGENTS.md update prevents a class of future failures. The investment compounds.

---

**[45:00 – 57:00] The Harness Audit**

Have the learner audit their own repository against the three pillars:

**Pillar 1 — Context Engineering**

| Question | In repo? |
|---|---|
| Is the project structure documented in a file an agent can read? | |
| Are architectural decisions recorded with rationale? | |
| Are known gaps and technical debt tracked in a file? | |
| Are active tasks or plans versioned in the repo? | |
| Is there anything the agent needs to know that only exists in chat, email, or someone's head? | |

**Pillar 2 — Architectural Constraints**

| Question | Enforced? |
|---|---|
| Are module boundary rules mechanical (linter/test) or just documented? | |
| Does CI fail on architectural violations? | |
| Are dependency direction rules tested automatically? | |
| Do agents get immediate feedback when they produce invalid output? | |

**Pillar 3 — Garbage Collection**

| Question | In place? |
|---|---|
| Is there a process for catching stale documentation? | |
| Does CI validate that AGENTS.md links resolve? | |
| Is there a periodic review of whether rules still apply? | |

For each gap identified, ask: *"What's the highest-leverage fix — what single change would prevent the most future failures?"*

---

**[57:00 – 60:00] Close**

Summarize to three statements:

1. The agent sees only the repository. If knowledge isn't in a file the agent can read, it doesn't exist. Harness engineering means externalizing everything — decisions, patterns, constraints, plans — into the repo as versioned, machine-readable artifacts.
2. The engineer's job is no longer to write code. It's to design environments, specify intent, and build feedback loops that catch mistakes mechanically. When the agent makes a mistake, the fix is an engineering change — not a retry.
3. A harness compounds. Every rule you add prevents a class of future failures. Every architectural constraint you mechanize removes a category of agent error. The work you do today makes every future session more reliable.

**Leave them with one action:** Pick the single highest-leverage gap from the audit — one thing the agent needs to know or one constraint that needs to be mechanical — and fix it before session 11. Session 11 is about writing specs for agents, and a well-harnessed repo is what makes a spec executable.

---

#### Facilitator Notes

- **The paradigm shift framing is the most important moment in the session.** Learners who internalize "my job is to engineer the environment, not correct the agent" leave with a fundamentally different orientation toward AI-assisted development. Don't rush past it.
- **Connect back to every previous session explicitly.** Session 1 (tokens as a resource) → context engineering. Session 6 (rules from failures) → the core Hashimoto loop. Sessions 7 and 8 (AGENTS.md + scoped rules) → Pillar 1 done right. Session 5 (evaluation protocol) → the feedback loop that feeds Pillar 3.
- **The audit is where the session becomes personal.** Generic harness concepts become real when the learner sees their own repository's gaps on paper. Don't skip it or abbreviate it.
- **If running a cohort:** Have each learner complete the audit independently, then compare results. The variation in what different repos are missing is itself a teaching moment — there's no universally complete harness, only a harness that's been improved by real failures.
- **Common question:** *"This sounds like a lot of upfront work — is it worth it?"* Point to the OpenAI result: a five-month internal experiment where engineers built and shipped a beta product containing roughly a million lines of code without any manually written source code. The harness is the leverage that makes that scale possible.
- **Connects forward to:** Session 11 (Writing Specs for Agents) — a spec is only executable if the harness is ready to receive it. Learners who complete the audit and close their highest-leverage gap before session 11 will write better specs because their environment is ready to run them.

---

---

### Session 11: Writing Specs for Agents

**Format:** 1-on-1 or small cohort | **Duration:** 60 minutes

#### Learning Objectives
By the end of this session, learners will be able to:
- Explain why a spec written for an agent is fundamentally different from a task description written for a human
- Identify gaps in a spec — places where an agent would fill in arbitrarily rather than execute with precision
- Write exhaustive Given → When → Then acceptance criteria that leave no room for agent inference
- Specify proof of work requirements that demonstrate behavior through HTTP records and Playwright scripts
- Produce a complete, executable agent spec for a real task in their own project

---

#### The Definition

An agent spec is not a description of what you want. It is a machine-executable contract that gives the agent everything it needs to complete a task with zero reliance on inference or assumption. Every gap in a spec is a place where the agent will make a decision you didn't authorize.

A complete spec contains:
- **Objective** — what the agent is being asked to accomplish, stated precisely
- **Scope** — what is explicitly in and out of bounds for this task
- **Relevant modules** — the exact files, classes, and functions the agent should reference or modify
- **Constraints** — what the agent must not do, even if it seems helpful
- **Acceptance criteria** — exhaustive Given → When → Then scenarios that define done. Every scenario is a contract clause.
- **Proof of work** — the artifacts the agent must produce to demonstrate each scenario passes: HTTP request/response records and Playwright scripts

---

#### The Deliberately Gapped Spec

Share this spec with learners at the start of the session:

```markdown
# Plan: Add Password Reset Endpoint

## Objective
Add a password reset flow to the authentication system. Users should
be able to request a password reset and complete it using a token.

## Relevant Modules
- `routers/auth.py`
- `services/auth_service.py`
- `models/user.py`

## What To Do
1. Create an endpoint that accepts an email address and sends a
   password reset token to the user.
2. Create an endpoint that accepts the token and a new password
   and updates the user's password.

## Constraints
- Do not modify existing authentication endpoints.

## Acceptance Criteria
- The reset token should expire after a reasonable amount of time.
- Tokens should be stored securely.
- The new password should meet security requirements.
- Errors should be handled appropriately.
- Tests should be written for the new endpoints.

## Proof of Work
- Demonstrate that the endpoints work correctly.
```

---

#### Session Flow

**[0:00 – 5:00] Frame the Session**

Open with the core distinction:

> *"A human reading this spec fills in the gaps from experience, convention, and common sense. They know what 'reasonable' means for a token expiry. They know what 'secure storage' implies. They know what 'security requirements' means for a password. An agent has none of that. Every gap is a decision point — and at every decision point, the agent will choose something. The question is whether it chooses what you would have chosen."*

Then introduce the exercise:

> *"Here's a spec. Before we run it, your job is to find every place where an agent would have to fill in a gap. Not just obvious problems — everything the agent would have to assume, infer, or decide on its own."*

Hand the learner the spec. Give them 3 minutes to read and mark gaps silently.

---

**[5:00 – 28:00] Part 1 — The Gap Hunt**

Work through the spec together. For each gap, ask:

> *"What would the agent decide here? Is every possible decision acceptable?"*

**Gap 1 — "A reasonable amount of time" (token expiry)**

*What the agent decides:* 15 minutes, 1 hour, 24 hours, 7 days — all defensible, none specified.

*Fix:*
```markdown
Reset tokens expire exactly 30 minutes after creation. After expiry
the token is permanently invalid. Expiry is enforced at the point of
validation — not just at creation. A new request generates a new token;
any previously issued unused tokens for the same user are immediately
invalidated.
```

**Gap 2 — "Stored securely" (token storage)**

*What the agent decides:* Plain text? Hashed? Separate table? Redis? In the user record?

*Fix:*
```markdown
Tokens are stored as SHA-256 hashes in a new `password_reset_tokens`
table: id, user_id (FK → users.id), token_hash (VARCHAR 64, unique),
expires_at (TIMESTAMP), used_at (TIMESTAMP nullable), created_at
(TIMESTAMP). The raw token is never persisted anywhere. The model
lives in `models/password_reset_token.py` following the existing
model pattern in that directory.
```

**Gap 3 — "Security requirements" (password validation)**

*What the agent decides:* Minimum length? Character requirements? Bcrypt rounds?

*Fix:*
```markdown
Password validation uses the existing `validate_password()` function
in `services/auth_service.py`. Do not implement new validation logic.
Password hashing uses the existing `hash_password()` function in the
same module. Do not introduce a new hashing implementation or change
the bcrypt work factor.
```

**Gap 4 — "Handled appropriately" (error handling)**

*What the agent decides:* 404 if email not found? 200 to prevent enumeration? Which status codes for which errors?

*Fix:*
```markdown
- Email not found: return 200 {"data": {"message": "If that email
  exists, a reset link has been sent."}, "error": null}
  — never reveal whether the email exists.
- Token invalid or expired: return 400
  {"data": null, "error": "Invalid or expired reset token."}
- Token already used: return 400
  {"data": null, "error": "This reset token has already been used."}
- New password fails validation: return 422
  {"data": null, "error": "<validation message from validate_password()>"}
- All responses use the standard envelope from `schemas/response.py`.
```

**Gap 5 — "Tests should be written" (acceptance criteria)**

*What the agent decides:* What to test, what scenarios to cover, what assertions to make, what passes.

*The lesson:* This is the biggest gap of all — and it's not fixable by describing tests better. It requires Given → When → Then scenarios.

---

**[28:00 – 50:00] Part 2 — Rewrite the Spec**

Rebuild the two weakest sections from scratch. Coach guides, learner writes.

**Acceptance Criteria — Given → When → Then**

```markdown
## Acceptance Criteria

### Request Reset

**Scenario 1 — Valid email**
Given a user exists with email `user@example.com`
When POST /auth/reset-password/request is called with
  body: {"email": "user@example.com"}
Then the response is 200 with
  body: {"data": {"message": "If that email exists, a reset link
  has been sent."}, "error": null}
And a password_reset_tokens record is created for the user
And the token_hash is a SHA-256 hash of the raw token
And expires_at is exactly 30 minutes from created_at
And used_at is null

**Scenario 2 — Email not found**
Given no user exists with email `nobody@example.com`
When POST /auth/reset-password/request is called with
  body: {"email": "nobody@example.com"}
Then the response is 200 with the identical body as Scenario 1
And no password_reset_tokens record is created

**Scenario 3 — Existing unused token is invalidated**
Given a user exists with an existing unused reset token
When POST /auth/reset-password/request is called for that user
Then the previous token record is deleted or marked invalid
And a new token record is created

**Scenario 4 — Invalid email format**
Given any request body
When POST /auth/reset-password/request is called with
  body: {"email": "not-an-email"}
Then the response is 422 with
  body: {"data": null, "error": "<pydantic validation message>"}

### Complete Reset

**Scenario 5 — Valid token and valid password**
Given a valid unexpired unused reset token exists for a user
When POST /auth/reset-password/complete is called with
  body: {"token": "<raw token>", "new_password": "ValidPass123!"}
Then the response is 200 with
  body: {"data": {"message": "Password successfully reset."},
  "error": null}
And the user's password_hash is updated in the users table
And the token's used_at is set to the current timestamp
And the user can authenticate with the new password
And the user cannot authenticate with the old password

**Scenario 6 — Expired token**
Given a reset token exists with expires_at in the past
When POST /auth/reset-password/complete is called with that token
Then the response is 400 with
  body: {"data": null, "error": "Invalid or expired reset token."}
And the user's password is unchanged

**Scenario 7 — Already used token**
Given a reset token exists with used_at set
When POST /auth/reset-password/complete is called with that token
Then the response is 400 with
  body: {"data": null, "error": "This reset token has already been used."}
And the user's password is unchanged

**Scenario 8 — Invalid token**
Given a token string that does not match any token_hash in the table
When POST /auth/reset-password/complete is called with that token
Then the response is 400 with
  body: {"data": null, "error": "Invalid or expired reset token."}

**Scenario 9 — Password fails validation**
Given a valid unexpired unused reset token
When POST /auth/reset-password/complete is called with
  body: {"token": "<raw token>", "new_password": "weak"}
Then the response is 422 with
  body: {"data": null, "error": "<message from validate_password()>"}
And the token remains unused
And the user's password is unchanged
```

**Proof of Work**

```markdown
## Proof of Work

The agent must produce the following artifacts in
`docs/evidence/reset-password/`:

### HTTP Records
For each scenario above, provide a file named
`scenario-<N>-<slug>.http` containing the exact curl command
and the full HTTP response including status code, headers, and body.

Example format:
# Scenario 1 — Valid email
$ curl -X POST http://localhost:8000/auth/reset-password/request \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com"}'

HTTP/1.1 200 OK
Content-Type: application/json

{"data": {"message": "If that email exists, a reset link has been
sent."}, "error": null}

### Playwright Scripts
Provide `reset_password_flow.py` — a Playwright script that:
1. Navigates to the password reset request form
2. Submits a valid email address
3. Asserts the success message is displayed
4. Retrieves the raw token from the test database
5. Navigates to the password reset completion form
6. Submits the token and a new valid password
7. Asserts the success message is displayed
8. Navigates to the login form
9. Logs in with the new password
10. Asserts successful authentication

The script must be executable with `playwright run reset_password_flow.py`
and must pass without manual intervention.
```

---

**[50:00 – 58:00] Part 3 — Learner Writes Their Own**

Learner picks a real task from their own project and writes a spec from scratch using the complete structure. Coach hunts for gaps in real time.

The coach's gap-hunting questions:
- *"What would the agent decide here that you haven't specified?"*
- *"Is every Given → When → Then scenario covered, including error paths?"*
- *"If the agent produced proof of work that satisfied every scenario, would you be confident shipping it?"*

The session ends when the learner has a spec they would actually run against an agent in their project.

---

**[58:00 – 60:00] Close — The Capstone**

Summarize the full workshop arc to three statements:

1. A spec written for an agent is a contract, not a description. It eliminates every gap where the agent would otherwise make a decision you didn't authorize — through precise constraints, exhaustive Given → When → Then scenarios, and proof of work that demonstrates behavior, not just existence.

2. Spec-driven development is the culmination of everything in this workshop. Tokens and context windows define what the agent can see. Prompt engineering shapes how it interprets instructions. The system prompt and rules define how it behaves. AGENTS.md and scoped rules make that behavior persistent and project-aware. The harness makes mistakes structurally impossible. The spec is what you run against all of it.

3. The mindset is the skill. Writing a spec that an agent can execute without filling in gaps requires you to think like the agent — to find every place where human inference would substitute for explicit instruction, and close it. That instinct, once developed, changes how you work with AI permanently.

---

#### Facilitator Notes

- **The gap hunt is the session.** Don't rush to the rewrite. The learner's ability to find gaps before running the spec is the skill that transfers to every future task. Spend time in the hunt.
- **Given → When → Then is non-negotiable.** If a learner writes an acceptance criterion that isn't in this form, ask them to rewrite it. "The token should expire" is not a criterion. "Given a token created 31 minutes ago, When the complete endpoint is called with that token, Then the response is 400" is a criterion.
- **The proof of work section is often the most surprising.** Most learners have never thought of specifying how the agent demonstrates completion — they assumed running the code was enough. The HTTP records and Playwright scripts make the spec auditable and replayable, not just executable once.
- **If running a cohort:** Have learners swap specs before Part 3 and hunt for gaps in each other's work. Peer gap-hunting is more rigorous than self-review and surfaces blind spots that familiarity creates.
- **Common question:** *"This takes a long time to write — is it faster just to prompt the agent directly?"* Answer: for a trivial task, yes. For anything with more than three moving parts, the time spent writing the spec is returned many times over in reduced rework, fewer misaligned implementations, and a proof of work that can be audited and rerun. The spec is also the documentation — when the feature ships, the Given → When → Then scenarios are the acceptance test suite.
- **The capstone framing matters.** This is the last session — close it by connecting every previous session to this moment. The learner started by understanding what a token costs. They end by writing a contract that an agent can execute against a harnessed repository with no gaps. That is the full arc.

---

*Workshop complete.*

---

## Advanced Workshop (Planned)

Topics flagged for the advanced workshop:
- Quantitative evals (evals-as-code, scoring, regression testing)
- Memory and state management (short-term vs. long-term, summarization vs. truncation)
- Multi-agent orchestration
- Autonomous agents
- Building the environment and tooling for production-grade agent workflows
