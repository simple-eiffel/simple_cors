# 7S-01: SCOPE

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Problem Domain

Cross-Origin Resource Sharing (CORS) is a security mechanism that allows web browsers to make requests to domains different from the origin of the web page. Without CORS, browsers block such requests by default (Same-Origin Policy).

CORS requires proper HTTP headers to be set by the server to indicate which origins, methods, and headers are permitted for cross-origin requests.

## Target Users

1. **Eiffel Web Application Developers** - Need to enable cross-origin access to their APIs
2. **simple_http Users** - Integrating CORS middleware into HTTP servers
3. **API Developers** - Building RESTful services consumed by web frontends

## Boundaries

### In Scope
- Origin validation and configuration
- HTTP method allowlist management
- Header allowlist and exposure configuration
- Credentials support (cookies, authorization)
- Preflight (OPTIONS) request handling
- Cache control (max-age)
- Pattern-based origin matching

### Out of Scope
- HTTP server implementation (provided by simple_http)
- Request routing
- Authentication/authorization beyond CORS credentials
- Content Security Policy (CSP)
- CORS proxy functionality

## Key Capabilities

1. **Multiple initialization modes:**
   - `make` - Default configuration (secure, explicit setup required)
   - `make_permissive` - Development mode (allows all)
   - `make_restrictive` - Production mode (nothing allowed by default)

2. **Origin management:**
   - Exact origin matching
   - Wildcard support (*)
   - Pattern-based matching

3. **Method and header control:**
   - Simple methods (GET, HEAD, POST) default-allowed
   - Custom method configuration
   - Header allowlist and exposure

4. **Preflight handling:**
   - Automatic OPTIONS request detection
   - Preflight response header generation
   - Cache control via max-age
