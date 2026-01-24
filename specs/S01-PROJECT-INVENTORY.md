# S01: PROJECT INVENTORY

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Project Structure

```
simple_cors/
├── src/
│   └── simple_cors.e          # Main CORS implementation
├── testing/
│   ├── test_app.e             # Test application entry
│   └── lib_tests.e            # Unit tests
├── research/                   # 7S research documents
├── specs/                      # Specification documents
├── simple_cors.ecf            # Library ECF
└── README.md                   # Documentation
```

## File Inventory

| File | Type | Lines | Purpose |
|------|------|-------|---------|
| simple_cors.e | Source | 633 | Main CORS class |
| test_app.e | Test | ~30 | Test entry point |
| lib_tests.e | Test | ~170 | Unit test suite |

## Dependencies

### External Dependencies
- None

### Eiffel Base Libraries
- ARRAYED_LIST
- HASH_TABLE
- STRING
- LIST

## Build Configuration

**ECF Targets:**
- `simple_cors` - Library target
- `simple_cors_tests` - Test target

## Version Information

- **Current Phase:** Production
- **API Stability:** Stable
- **Eiffel Version:** 25.02+
