<p align="center">
  <img src="https://raw.githubusercontent.com/ljr1981/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_ library logo" width="400">
</p>

# simple_cors

**[Documentation](https://simple-eiffel.github.io/simple_cors/)**

CORS (Cross-Origin Resource Sharing) handling library for Eiffel following the Fetch Standard specification.

## Features

- **Fetch Standard compliant** - Implements CORS per WHATWG Fetch specification
- **Fluent configuration API** - Chain methods for easy setup
- **Origin validation** - Exact match or wildcard patterns
- **Preflight handling** - Automatic OPTIONS request response headers
- **Credential support** - Properly handles Access-Control-Allow-Credentials
- **Header exposure** - Control which headers JavaScript can access
- **Preflight caching** - Configurable max-age for browser caching
- **Design by Contract** - Full preconditions/postconditions

## Installation

Add to your ECF:

```xml
<library name="simple_cors" location="$SIMPLE_CORS\simple_cors.ecf"/>
```

Set environment variable:
```
SIMPLE_CORS=D:\prod\simple_cors
```

## Usage

### Development (Permissive)

```eiffel
local
    cors: SIMPLE_CORS
do
    create cors.make_permissive  -- Allows all origins, methods, headers
end
```

### Production (Restrictive)

```eiffel
local
    cors: SIMPLE_CORS
do
    create cors.make
    cors.allow_origin ("https://example.com")
    cors.allow_origin ("https://app.example.com")
    cors.allow_method ("PUT")
    cors.allow_method ("DELETE")
    cors.allow_header ("Authorization")
    cors.allow_credentials
    cors.set_max_age (86400)  -- Cache preflight for 24 hours
end
```

### Handling Requests

```eiffel
local
    cors: SIMPLE_CORS
    headers: HASH_TABLE [STRING, STRING]
    origin: STRING
do
    origin := request.header ("Origin")

    if cors.is_cors_request (origin) then
        if cors.is_origin_allowed (origin) then
            if cors.is_preflight_request (request.method, origin) then
                -- OPTIONS preflight
                headers := cors.headers_for_preflight (
                    origin,
                    request.header ("Access-Control-Request-Method"),
                    request.header ("Access-Control-Request-Headers")
                )
                response.set_status (204)
            else
                -- Actual request
                headers := cors.headers_for_simple_request (origin)
            end
            -- Add headers to response
            across headers as h loop
                response.add_header (h.key, h.item)
            end
        else
            response.set_status (403)  -- Forbidden
        end
    end
end
```

### Origin Patterns

```eiffel
-- Allow all subdomains
cors.allow_origin_pattern ("https://*.example.com")

-- Allow any origin (development only!)
cors.allow_all_origins
```

## API Reference

### Initialization

| Feature | Description |
|---------|-------------|
| `make` | Create with sensible defaults (must configure origins) |
| `make_permissive` | Allow all origins/methods/headers (development) |
| `make_restrictive` | Allow nothing until configured (production) |

### Origin Configuration

| Feature | Description |
|---------|-------------|
| `allow_origin (url)` | Add exact origin to allowed list |
| `allow_origins (array)` | Add multiple origins |
| `allow_origin_pattern (pattern)` | Add wildcard pattern |
| `allow_all_origins` | Allow any origin (use "*") |
| `disallow_all_origins` | Disable wildcard mode |

### Method Configuration

| Feature | Description |
|---------|-------------|
| `allow_method (method)` | Add HTTP method to allowed list |
| `allow_methods (array)` | Add multiple methods |
| `allow_all_methods` | Allow GET, HEAD, POST, PUT, DELETE, PATCH, OPTIONS |

### Header Configuration

| Feature | Description |
|---------|-------------|
| `allow_header (header)` | Add request header to allowed list |
| `allow_headers (array)` | Add multiple headers |
| `allow_all_headers` | Allow any request header |
| `expose_header (header)` | Expose response header to JavaScript |
| `expose_headers (array)` | Expose multiple headers |

### Credentials & Caching

| Feature | Description |
|---------|-------------|
| `allow_credentials` | Allow cookies/auth (disables wildcard origin) |
| `disallow_credentials` | Disallow credentials |
| `set_max_age (seconds)` | Preflight cache duration |

### Request Processing

| Feature | Description |
|---------|-------------|
| `is_cors_request (origin)` | Does request have Origin header? |
| `is_preflight_request (method, origin)` | Is this an OPTIONS preflight? |
| `is_origin_allowed (origin)` | Is origin in allowed list? |
| `is_method_allowed (method)` | Is method allowed? |
| `is_header_allowed (header)` | Is header allowed? |
| `are_headers_allowed (headers)` | Are all comma-separated headers allowed? |

### Response Headers

| Feature | Description |
|---------|-------------|
| `headers_for_simple_request (origin)` | Generate CORS headers for actual request |
| `headers_for_preflight (origin, method, headers)` | Generate CORS headers for OPTIONS |

## CORS Headers Generated

| Header | Description |
|--------|-------------|
| `Access-Control-Allow-Origin` | Allowed origin or "*" |
| `Access-Control-Allow-Methods` | Allowed methods (preflight) |
| `Access-Control-Allow-Headers` | Allowed headers (preflight) |
| `Access-Control-Allow-Credentials` | "true" if credentials allowed |
| `Access-Control-Expose-Headers` | Headers exposed to JavaScript |
| `Access-Control-Max-Age` | Preflight cache seconds |
| `Vary` | "Origin" for proper caching |

## Design Decisions

This library was designed after researching existing CORS implementations and the Fetch Standard specification:

### Research Findings

**Competitor Analysis:**
- Most CORS libraries are either too permissive (security risk) or too complex (hard to configure)
- Common pain points: unclear error messages, difficult debugging, credential handling confusion

**Fetch Standard Compliance:**
- Implements CORS per [WHATWG Fetch Standard](https://fetch.spec.whatwg.org/#http-cors-protocol)
- Proper handling of "null" origin (always rejected for security)
- Correct Vary header for caching

**Key Design Choices:**
1. **Three constructors** - `make` (configure yourself), `make_permissive` (dev), `make_restrictive` (prod)
2. **Credentials disable wildcard** - Enforced by class invariant, not just documentation
3. **Fluent API** - Chainable configuration methods
4. **Pattern matching** - Simple wildcards for subdomain support
5. **Header generation** - Returns hash table for easy integration with any web framework

## Security Notes

- **Never use `allow_all_origins` in production** with sensitive data
- **Credentials require specific origin** - wildcard "*" not allowed
- **Validate origins carefully** - pattern matching can be dangerous
- **Always set appropriate max-age** - reduces preflight requests

## Dependencies

- EiffelBase

## License

MIT License - Copyright (c) 2024-2025, Larry Rix
