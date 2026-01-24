# 7S-02: STANDARDS


**Date**: 2026-01-23

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Applicable Standards

### Primary Standard

**Fetch Standard - CORS Protocol**
- URL: https://fetch.spec.whatwg.org/#http-cors-protocol
- Maintained by: WHATWG
- Status: Living Standard

The Fetch Standard defines the CORS protocol as part of the broader fetch algorithm used by browsers.

### Related Standards

**RFC 6454 - The Web Origin Concept**
- Defines the "origin" of a web resource
- Format: scheme://host:port

**MDN CORS Documentation**
- Practical implementation guidance
- Browser compatibility information

## Key Protocol Requirements

### Simple Requests
- Methods: GET, HEAD, POST
- Simple headers: Accept, Accept-Language, Content-Language, Content-Type (with restrictions)
- No preflight required

### Preflighted Requests
- Non-simple methods or headers trigger OPTIONS preflight
- Preflight must include Access-Control-Request-Method
- Server responds with Access-Control-Allow-* headers

### Required Response Headers

| Header | Purpose |
|--------|---------|
| Access-Control-Allow-Origin | Permitted origin or * |
| Access-Control-Allow-Methods | Permitted HTTP methods |
| Access-Control-Allow-Headers | Permitted request headers |
| Access-Control-Expose-Headers | Headers accessible to JS |
| Access-Control-Allow-Credentials | Permit cookies/auth |
| Access-Control-Max-Age | Preflight cache duration |
| Vary | Caching variance indicator |

### Security Constraints

1. Wildcard (*) cannot be used with credentials
2. "null" origin must be explicitly blocked (security risk)
3. Vary header required for correct caching
