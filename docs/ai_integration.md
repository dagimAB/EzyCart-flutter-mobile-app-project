# AI Assistant Integration (EzyCart)

## Overview

This document explains how the AI Assistant is integrated into EzyCart, how to configure it, and how to replace the placeholder AI endpoint with a real Gemini API.

## Files added

- `lib/services/ai/ai_assistant_service.dart` — wrapper service that calls an AI provider via HTTP. **TODO**: replace endpoint and implement secure API key retrieval.
- `lib/features/ai/controllers/ai_chat_controller.dart` — GetX controller that manages chat messages and loading state.
- `lib/features/ai/screens/ai_chat_screen.dart` — Chat UI with message bubbles and input.
- Entry point: an AI icon was added to the Home app bar (`Icons.smart_toy`) which opens `AiChatScreen`.

## Setup & TODOs

1. Add your Gemini or AI provider API key securely. Suggested approaches:

   - Store in `.env` and load via `flutter_dotenv` (development).
   - On devices, store secrets using `flutter_secure_storage`.

2. Update `AiAssistantService._endpoint` and the payload/response handling to match your provider's API.

3. (Optional) Add provider SDK dependency if preferred (e.g., `google_generative_ai`) and implement richer request/response handling.

## Usage

- Open Home screen and tap the AI Assistant icon (top-right). Type a question and press send.
- Responses are shown as assistant messages; navigation queries should be answered with precise screen paths.

## System Prompt & Rules

The assistant should always start new sessions with "Welcome to EzyCart!" and follow the scope/rules described in the project docs. See `docs/ui_flow.md` for the app navigation structure the AI should use.

## Security & Guardrails

- The code includes a TODO placeholder for the API key; do NOT commit secrets.
- The integration does NOT modify `AuthenticationRepository` or any data models.

## Contact

If you want me to wire up a specific AI provider (OpenAI, Gemini, HuggingFace), tell me which one and I will implement provider-specific code and add recommended dependency entries.
