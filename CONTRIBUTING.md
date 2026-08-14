# Contributing

MemoryGuard favors small, testable changes that preserve its non-destructive
safety contract.

1. Fork the repository and create a focused branch.
2. Add or update tests for behavior changes.
3. Run `swift test` and `swift build -c release`.
4. Explain the user impact and safety implications in the pull request.

New process recognizers must be exact allow-list rules. A command merely
mentioning a build tool is not sufficient evidence that it is a build process.
