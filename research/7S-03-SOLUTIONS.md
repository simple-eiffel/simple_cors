# 7S-03: SOLUTIONS


**Date**: 2026-01-23

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Existing Solutions Comparison

### Language-Specific Libraries

| Solution | Language | Approach | Complexity |
|----------|----------|----------|------------|
| cors (npm) | JavaScript | Middleware | Simple |
| rack-cors | Ruby | Rack middleware | Simple |
| django-cors-headers | Python | Django middleware | Medium |
| rs/cors | Go | http.Handler wrapper | Simple |
| **simple_cors** | **Eiffel** | **Header generator** | **Simple** |

### Design Approaches

**1. Middleware Pattern (Most Common)**
- Intercepts all requests
- Automatically handles OPTIONS
- Adds headers to responses
- Example: cors (npm), rack-cors

**2. Header Generator Pattern (simple_cors)**
- Generates CORS headers on demand
- Application controls when/how headers are added
- More flexible, requires explicit integration
- Allows fine-grained control per endpoint

**3. Configuration-Based**
- YAML/JSON configuration files
- Server-level setup
- Example: nginx cors module

### Why Header Generator Pattern?

1. **Separation of concerns** - CORS logic separate from HTTP handling
2. **Testability** - Easy to unit test header generation
3. **Flexibility** - Can apply different CORS policies per endpoint
4. **Integration** - Works with any HTTP server library
5. **Explicit** - No "magic" middleware behavior

## Differentiation

simple_cors focuses on:
- Contract-based API (Design by Contract)
- Explicit configuration over convention
- Header generation rather than request interception
- Integration with simple_http ecosystem
