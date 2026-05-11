---
name: clean-rspec-output
description: Systematically identify and fix unexpected RSpec output (Ruby warnings, gem deprecations, stray debug output, ActiveRecord warnings, third-party library output). Uses binary search to isolate problematic specs, grep-based pattern matching to locate code, and targeted fixes by warning category. No complex tracing required—just systematic narrowing and direct code inspection.
compatibility: Requires Ruby project with RSpec and `make test` support
---

# Clean RSpec Output

When test output contains unexpected warnings, deprecations, stray debug output, or third-party library noise, use this systematic three-step workflow to identify and fix the root causes.

## When to Use This Skill

Use this when test output contains:
- Ruby or gem deprecation warnings
- SQL/database warnings (format string, placeholder mismatches)
- Debug output accidentally left in code (puts, p, pp, warn)
- Uncontrolled third-party library output
- Any other unexpected warnings or noise in test runs

## Workflow: Three Steps to Clean Output

### Step 1: Narrow Down Which Specs Trigger Warnings (Binary Search with Fixed Seed)

**CRITICAL: RSpec randomizes test order by default. Warnings that only appear in full suite runs are seed-dependent.**

Run your full test suite once to capture a reproducible seed, then use that seed for all binary search steps:

**Count total warnings and capture seed:**

> **Note:** Warnings are printed to stderr. Always use `2>&1` to merge
> stderr into stdout — otherwise `grep "warning:"` will match nothing
> even when warnings are present.

```bash
make test 2>&1 | tee /tmp/test_output.log | grep "warning:" | wc -l
SEED=$(grep "Randomized with seed" /tmp/test_output.log | tail -1 | awk '{print $NF}')
echo "Captured seed: $SEED"
```

**Binary search by directory with fixed seed** (divide the spec directory tree in half each time):
```bash
# Always run sequentially with the same seed to maintain deterministic output
# Parallel spec execution can corrupt database state and introduce non-deterministic warnings
make test SPEC=spec/domain SEED=$SEED 2>&1 | grep "warning:" | wc -l
make test SPEC=spec/api SEED=$SEED 2>&1 | grep "warning:" | wc -l
```

*Note: If your project doesn't support `SEED=` via make, substitute with `bundle exec rspec spec/domain --seed $SEED` or the appropriate RSpec invocation. Always run sequentially.*

> **Watch out — `make test` may suppress warnings that `bundle exec rspec` surfaces.**
> Projects often set a high log level (e.g. `LOGGER_LEVEL=fatal`) in the Makefile,
> which can hide warnings during binary search. If a directory shows zero warnings
> under `make test` but the full suite shows many, cross-check by running the same
> files directly with `bundle exec rspec` to confirm whether the warnings are truly
> absent or just suppressed.

**Once you've found the directory, narrow to individual spec files (sequentially):**
```bash
# Test files one by one with the fixed seed
for file in spec/domain/offers/*_spec.rb; do
  warnings=$(bundle exec rspec "$file" --seed $SEED 2>&1 | grep "warning:" | wc -l)
  echo "$(basename $file): $warnings warnings"
done
```

**When binary search stalls, use `--format documentation` to pinpoint the exact test:**

`--format documentation` is the most effective tool for locating warnings. It prints
the spec description hierarchy as tests run, so warnings appear immediately after the
context name they fired in — telling you exactly which test body triggered them.

```bash
# Run the smallest suspect set with documentation format
# Look at what is printed immediately BEFORE each warning line
bundle exec rspec spec/domain/some_area --seed $SEED --format documentation 2>&1 | grep -B 3 "warning:"
```

If individual files don't trigger warnings (test interaction), run the suspect pair together:
```bash
# Seed-dependent warnings only appear in specific test orderings
bundle exec rspec spec/a_spec.rb spec/b_spec.rb --format documentation 2>&1 | grep -B 3 "warning:"
```

This reveals which specific test context triggers the warning even when the file in isolation shows nothing.

### Step 2: Search the Codebase for the Pattern

Once you know which tests trigger the warning, search the codebase for the code pattern causing it:

**For format string warnings** (most common with ActiveRecord):
```bash
# Find all sanitize_sql_array calls with potential mismatches
grep -r "sanitize_sql_array" --include="*.rb" | grep -v spec | grep -v ".git"

# Find update_all with array-based SQL
grep -r "update_all.*\[" --include="*.rb" | grep -v spec | grep -v ".git"

# Find IN (?) clauses or other SQL parameter issues
grep -r "IN\|sanitize_sql\|\.query\|\.execute" --include="*.rb" | grep -v spec | grep -v ".git"
```

**For deprecation warnings:**
```bash
# Search for the deprecated method name
grep -r "deprecated_method_name" --include="*.rb" | grep -v spec | grep -v ".git"
```

**For stray debug output:**
```bash
# Find puts/p/pp calls that aren't in logging
grep -r "^\s*puts\|^\s*p\s\|^\s*pp\s" --include="*.rb" | grep -v spec | grep -v ".git"
```

The grep results should point directly to the problematic code.

### Step 3: Locate and Fix the Code

Use the grep results from Step 2 to locate the problematic code and apply targeted fixes.

#### Fix Strategy by Warning Category

**SQL/Database warnings** (e.g., "too many arguments for format string", "misaligned placeholders"):
- Check: SQL placeholder count (`?` or named params like `:param`) matches the number of values passed
- Check: Helper methods with optional default parameters (e.g., `def query(sql, params = {})`) — ensure empty params are not passed to `sanitize_sql_array` unchanged
- Check: No empty/nil parameters passed where they shouldn't be
- Fix: Align the SQL template with its parameters, or skip parameter binding if params are empty (e.g., `params.empty? ? sql : sanitize_sql_array([sql, params])`)

**Deprecation warnings** (from Ruby or gem):
- Read the warning message for the recommended replacement
- Replace deprecated syntax/method with its modern equivalent
- Example: if warning says "use X instead of Y", replace all Y with X

**Stray debug output** (puts, p, pp, console.log, etc.):
- Locate via grep: `grep -r "^\s*puts\|^\s*p\s\|^\s*pp\s" --include="*.rb"`
- Remove the debug line entirely
- Or wrap in conditional: `warn "debug info" if ENV["DEBUG"]`
- Confirm the test isn't intentionally validating that output before removing

**Third-party library noise:**
- Identify which gem is outputting (check Gemfile.lock and warning source)
- Search the gem's docs for suppression options (config files, env vars, logger levels)
- Apply the gem's recommended suppression method
- As a last resort, redirect stderr during test setup if no other option exists

## Verification

After applying fixes, re-run the full test suite:

```bash
make test
```

Or if using `rspec` directly:

```bash
bundle exec rspec
```

Verify:
- All tests still pass
- The specific warnings are gone
- No new warnings introduced

Use the same command that triggered the warning originally—this ensures consistency in how tests are run.

## Anti-Patterns to Avoid

- **Don't skip the investigation step.** Fixing without understanding the root cause can mask deeper issues or introduce bugs.
- **Don't suppress warnings in production code as a permanent fix.** Use env vars or logger levels only for investigation, not as final solutions.
- **Don't assume the warning source is obvious.** Use binary search with a fixed seed to narrow down the exact test context before fixing.
- **Don't batch multiple unrelated warnings together.** Each distinct warning type (Ruby deprecation vs. SQL vs. debug output) requires a different investigation strategy.
- **Don't use complex tracing when simple grep + binary search will work.** Grep the codebase first, then apply targeted fixes.
- **Don't run specs in parallel during investigation.** Database state is shared across specs. Parallel execution introduces non-deterministic warnings and corrupts results. Always run sequentially with a fixed seed.
- **Don't change code without proof of root cause.** Seed-dependent warnings that vanish in isolated spec directory runs are hard to pinpoint. If you can't definitively prove which code triggers the warning after reasonable investigation, stop and document what you found.

## Quick Reference: Warning Patterns

| Warning | Pattern | Fix |
|---------|---------|-----|
| "too many arguments for format string" | SQL placeholders don't match parameter count OR empty params passed to sanitize_sql_array | Align SQL template with values, or check if empty params should skip sanitization |
| "deprecated ... is deprecated" | Old method/syntax being used | Replace with newer equivalent from warning message |
| Unexpected output in test results | Debug statements (puts, p, warn) left in code | Remove or conditionally wrap with `if ENV["DEBUG"]` |
| Library warnings/noise | Third-party gem outputting to stderr | Check gem docs for suppression config/env vars |
