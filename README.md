# AI Moderated Chat (Dart CLI)

A minimal command‑line chat client that calls OpenAI's Chat Completions API and applies a simple on‑device moderation layer before sending the user prompt and before printing the AI response. The moderation checks for a small set of banned keywords and redacts them if needed.

## Overview

- Stack: Dart 3 CLI application
- Entry point: `bin/ai_moderated_chat.dart` (`main()`)
- Package manager: Dart `pub`
- Key dependencies: 
  - `http` for HTTP requests
  - `args` (currently unused in code; reserved for future CLI flags)
  - `path` for filesystem path handling
- Tests: `package:test` is configured (sample test file present)

## Requirements

- Dart SDK: `^3.8.1` (see `pubspec.yaml`)
- Internet access
- OpenAI API key

## Getting Started

1. Install Dart (if you don’t have it): https://dart.dev/get-dart
2. Clone this repository and open it in your terminal.
3. Install dependencies:
   ```bash
dart pub get
```
4. Create a `.env` file in the project root with your API key:
   ```env
API_KEY=sk-your-openai-key
```
   Notes:
   - The program reads `.env` from the current working directory (`Directory.current`). If you run the app from elsewhere, ensure the `.env` is in that working directory or adjust how you launch it.

## Running the App

Run from the project root (recommended so `.env` is discovered):

```bash
dart run bin/ai_moderated_chat.dart
```

You will be prompted to enter a message. Type `exit` to quit.

## How It Works

- Moderation: `lib/moderation.dart` contains a simple list of banned keywords (`kill`, `hack`, `bomb`, `murder`, `explosive`).
  - User input is checked before being sent to the API. If it contains banned content, the request is aborted.
  - The AI’s response is also checked; if any banned keyword appears, it is redacted as `[REDACTED]`.
- Prompting: `lib/prompts.dart` provides a brief system prompt encouraging safe, helpful behavior.
- API call: `bin/ai_moderated_chat.dart` posts to `https://api.openai.com/v1/chat/completions` with model `gpt-3.5-turbo` and prints the first message choice.
- API key loading: `lib/env.dart` reads `.env` and extracts `API_KEY=...`.

## Configuration

Environment variables (via `.env`):

- `API_KEY` (required): Your OpenAI API key.

Moderation list:
- You can update `bannedKeywords` in `lib/moderation.dart` to refine the moderation policy.

## Scripts and Useful Commands

- Install dependencies:
  ```bash
dart pub get
```
- Run the app:
  ```bash
dart run bin/ai_moderated_chat.dart
```
- Run tests:
  ```bash
dart test
```
- Static analysis (uses `analysis_options.yaml` with `lints`):
  ```bash
dart analyze
```
- Format code:
  ```bash
dart format .
```

Note: There are no custom `pub` run scripts configured in `pubspec.yaml` at this time.

## Tests

- Test framework: `package:test`.
- Current state: `test/ai_moderated_chat_test.dart` contains a commented sample test. You can add tests around moderation utilities (e.g., `containsBannedWord`, `redactBannedWords`).

Run the test suite:
```bash
dart test
```

## Project Structure

```
.
├─ bin/
│  └─ ai_moderated_chat.dart      # CLI entrypoint; reads stdin, calls API, applies moderation
├─ lib/
│  ├─ env.dart                    # Loads API key from .env (API_KEY=...)
│  ├─ moderation.dart             # Banned words list and helpers
│  └─ prompts.dart                # System prompt for the assistant
├─ test/
│  └─ ai_moderated_chat_test.dart # Sample test (currently commented)
├─ pubspec.yaml                   # Package metadata and dependencies
├─ analysis_options.yaml          # Lints configuration
├─ CHANGELOG.md                   # Change history
└─ README.md
```

## Troubleshooting

- `.env file not found` or `API_KEY not found in .env`:
  - Ensure a `.env` file exists in your current working directory with `API_KEY=...`.
  - Run the app from the project root where `.env` is located.
- `API Error` with status code and JSON body:
  - Check your API key, network connectivity, and account limits.
  - OpenAI’s `gpt-3.5-turbo` and the `chat/completions` endpoint may be subject to deprecation/changes.
