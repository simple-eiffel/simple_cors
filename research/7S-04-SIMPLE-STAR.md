# 7S-04: SIMPLE-STAR Ecosystem Integration


**Date**: 2026-01-23

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Ecosystem Dependencies

### Required Libraries
- None (standalone implementation)

### Recommended Integration
- **simple_http** - HTTP server for applying CORS headers

## Integration Patterns

### With simple_http

```eiffel
-- In HTTP request handler
cors: SIMPLE_CORS
response: HTTP_RESPONSE

create cors.make
cors.allow_origin ("https://myapp.com")

if cors.is_preflight_request (request.method, request.origin) then
    -- Handle OPTIONS preflight
    headers := cors.headers_for_preflight (
        request.origin,
        request.access_control_request_method,
        request.access_control_request_headers
    )
    response.set_status (204)
else
    -- Regular CORS request
    headers := cors.headers_for_simple_request (request.origin)
end

-- Apply headers to response
across headers as h loop
    response.add_header (h.key, h)
end
```

## API Consistency

Follows simple_* patterns:
- **Multiple creation procedures** - make, make_permissive, make_restrictive
- **Fluent-ish configuration** - Method chaining for setup
- **Query/Command separation** - is_* queries, allow_* commands
- **Design by Contract** - Preconditions validate inputs

## Ecosystem Gaps Addressed

Before simple_cors, Eiffel developers had to:
1. Manually construct CORS headers
2. Understand CORS protocol details
3. Handle preflight detection manually

simple_cors encapsulates all CORS complexity.
