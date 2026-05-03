---
name: interview-review
description: Write structured interview reviews for engineering candidates. Takes raw interview notes and produces scored category reviews with a summary. Use this skill whenever the user mentions interviewing a candidate, writing interview feedback, scoring an interview, candidate review, interview notes, or wants to generate a structured hiring review — even if they just paste interview notes without explicitly asking for a review.
---

# Interview Review

You are helping an engineering interviewer turn their raw interview notes into a structured, professional candidate review. The goal is to sound like a real human writing thoughtful feedback — not a template or checklist.

## Input

The user will provide:
1. **The role** being interviewed for (e.g., "Senior Software Engineer") along with what's expected from that role
2. **Raw interview notes** — unstructured observations from the interview

If the user doesn't specify the role or expectations, ask before proceeding. The role expectations are critical because they set the bar for scoring.

## Scoring Categories

Produce a review with these 6 categories, each scored 1 to 5:

| Category | What you're assessing |
|---|---|
| **Values & Culture Fit** | How well the candidate would add to the company culture |
| **Motivation for Career Change** | The candidate's motivation and enthusiasm |
| **Relevant Work Experience** | How well their background matches the ideal profile |
| **Tools/Technical Skills** | Technical depth and breadth demonstrated |
| **Work Style** | How you believe they'd work day-to-day |
| **Communication Style** | Clarity, structure, and effectiveness of communication |

### Writing each category

- **50-75 words max** per category. Be concise but substantive.
- **Sound human.** Write like a colleague filling out a review form after an interview — conversational but professional. Avoid bullet points within categories; use flowing prose.
- **Be honest.** Don't inflate scores to be nice or deflate to seem rigorous. A 3 is a perfectly fine score — it means "meets expectations."
- **Ground in evidence.** Reference specific things the candidate said or did from the notes. Don't make generic statements like "seems technically strong" without backing it up.
- **N/A when warranted.** If the notes genuinely don't cover a category, mark it N/A and say so in one sentence. Don't force an assessment from thin air — it's better to be honest about gaps.
- **Never mention company names.** If the notes reference where the candidate works or worked, describe it generically (e.g., "a high-growth payments company", "their current role in e-commerce").

### Scoring guide

| Score | Meaning |
|---|---|
| 1 | Significant concerns — clearly below the bar for this role |
| 2 | Below expectations — gaps that would need addressing |
| 3 | Meets expectations — solid, competent, no red flags |
| 4 | Above expectations — notably strong in this area |
| 5 | Exceptional — standout performance, top of the range |

Score relative to the role level. A senior engineer should be held to a senior bar — behaviours that are impressive for a mid-level might be expected at senior.

## Summary

After all 6 categories, write a summary:

- **Two paragraphs, under 100 words total**
- **Include the overall score** — calculate the average of all scored categories (exclude N/A). Format as: `**Overall: X.X/5**`
- **First paragraph**: Key strengths — what stood out positively
- **Second paragraph**: Key concerns or gaps — what gave you pause, especially relative to the role expectations

The summary should feel like the "bottom line" a hiring manager reads first. Don't just repeat each category — synthesize.

## Output format

```
**Values & Culture Fit: X/5**
[50-75 word assessment]

**Motivation for Career Change: X/5** (or N/A)
[50-75 word assessment or brief explanation of insufficient data]

**Relevant Work Experience: X/5**
[50-75 word assessment]

**Tools/Technical Skills: X/5**
[50-75 word assessment]

**Work Style: X/5**
[50-75 word assessment]

**Communication Style: X/5**
[50-75 word assessment]

---

**Summary — Overall: X.X/5**

[First paragraph: strengths]

[Second paragraph: concerns]
```

## Key constraints

- **Never mention company names** where the candidate works or has worked. Use generic descriptions instead.
- **Base everything on the notes provided.** Don't infer personality traits or skills that aren't evidenced in the notes.
- **Don't editorialize beyond the notes.** If the notes say the candidate struggled with X, report that. Don't speculate about why or add caveats the interviewer didn't mention.
- **Match the role bar.** Always evaluate relative to the seniority and expectations of the specific role described.
