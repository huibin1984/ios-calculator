# Changelog

All notable changes to this project will be documented in this file.

## [v2.5] - 2026-03-11

### Added

**🔊 Equation Solver Voice Feedback (v2.5)**
- Equation solver now provides voice feedback when solving equations
- Announces solutions verbally for accessibility
- Uses existing `VoiceManager` infrastructure
- Supports both success and error messages

## [v2.4] - 2026-03-11

### Added

**↔️ Calculator ↔ Equation Solver Bridge (v2.4)**
- "Send to Equation Solver" button in DisplayView
- One-click transfer of calculator results to equation solver
- New `CalculatorSolverBridgeViewModel` for managing cross-module data flow
- Haptic feedback on successful transfer
- Future-ready architecture for bidirectional communication

## [v2.3] - 2026-03-11

### Added

**🎤 Voice Input Button (v2.3)**
- Microphone button in top bar (next to voice toggle)
- Activates speech-to-text for number input
- Smart parsing: auto-detects numbers and operators
- Natural language support:
  - Numbers: "一", "二", "三"... or "1", "2", "3"...
  - Operators: "加" (+), "减" (-), "乘" (×), "除" (÷)
- Tokenizes input and executes operations sequentially
- Haptic feedback on activation

---

## [v2.2] - 2026-03-11

### Added

**📜 Transaction History Panel**
- Complete operation history with timestamps
- Swipe-left to delete individual entries
- Batch "Clear All" functionality
- Persistent storage via `UserDefaults`
- Animated slide-in panel (50% screen width)

---

## [v2.1] - 2026-03-11

### Added

**🧮 Memory Functions (M+, M-, MR, MC)**
- `M+`: Add current value to memory
- `M-`: Subtract from memory
- `MR`: Recall stored value
- `MC`: Clear memory
- "M" indicator on display when memory is active

---

## [v2.0] - 2026-03-11

### Added

**🔊 Voice Toggle Switch (v2.0)**
- On/off toggle for voice feedback
- Language selector: English / Chinese
- Visual indicator with sound icon
- Respects user preference globally

---

## [v1.3] - 2026-03-11

### Added

**📐 Scientific Mode**
- Advanced functions: sin, cos, tan, log, sqrt, pow
- Toggle between Basic and Scientific modes
- Animated button transitions

---

## [v1.0] - 2026-03-11

### Initial Release

- Basic arithmetic operations (+, -, ×, ÷)
- Decimal point support
- Clear (C) and Delete (⌫) buttons
- Result calculation with "="
- MVVM architecture foundation
