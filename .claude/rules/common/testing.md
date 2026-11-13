# Testing Requirements

## Minimum Test Coverage: 80%

Test Types (ALL required):
1. **Unit Tests** - Individual functions, utilities, components
2. **Integration Tests** - API endpoints, database operations
3. **E2E Tests** - Critical user flows (framework chosen per language)

## Test-Driven Development

MANDATORY workflow:
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)

## Troubleshooting Test Failures

1. Use **tdd-guide** agent
2. Check test isolation
3. Verify mocks are correct
4. Fix implementation, not tests (unless tests are wrong)

## Agent Support

- **tdd-guide** - Use PROACTIVELY for new features, enforces write-tests-first

## Test Quality Gate — test-guard (MANDATORY)

**Invoke `/test-guard` before presenting, committing, or merging any test code.**

Trigger conditions (ALL require `/test-guard`):
- After writing new test functions or test files
- After editing existing tests
- When reviewing a diff that contains test changes
- When the user asks to write, add, or review tests

The skill enforces nine rules against the most common AI test-generation failures:
1. Test behavior, not implementation (no asserting internal mocks)
2. Mock only at system boundaries (network, DB, filesystem, clock, third-party SDKs)
3. One scenario per test; data-driven for value variants
4. Every test must justify its existence ("what bug does this catch?")
5. Name tests for the scenario, not the function signature
6. Production regression tests are sacred — never delete them
7. No tests for framework guarantees (validation, routing, ORM defaults)
8. State and value objects are always real instances, never mocked
9. Infrastructure under test uses real infrastructure

**Never skip `/test-guard` because the tests "look fine" — invoke the skill and let it confirm.**
