# S04: FEATURE SPECIFICATIONS

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Initialization Features

### make
**Signature:** `make`
**Purpose:** Create with secure defaults (no origins allowed, must configure)
**Behavior:**
- Initializes all lists
- Sets default methods (GET, HEAD, POST)
- Sets default headers (accept, accept-language, content-language, content-type)
- Credentials disabled
- Max age set to Default_max_age (86400)

### make_permissive
**Signature:** `make_permissive`
**Purpose:** Development mode - allows all origins, methods, headers
**Behavior:**
- Calls make
- Enables allow_all_origins_enabled
- Calls allow_all_methods
- Calls allow_all_headers

### make_restrictive
**Signature:** `make_restrictive`
**Purpose:** Production mode - nothing allowed until configured
**Behavior:**
- Creates empty lists
- No default methods or headers
- Credentials disabled

## Origin Configuration

### allow_origin
**Signature:** `allow_origin (a_origin: STRING)`
**Purpose:** Add exact origin to allowed list
**Behavior:**
- Adds origin if not already present
- Disables wildcard mode

### allow_origin_pattern
**Signature:** `allow_origin_pattern (a_pattern: STRING)`
**Purpose:** Add wildcard pattern for origin matching
**Behavior:**
- Supports * as wildcard
- Pattern checked after exact matches

### allow_all_origins
**Signature:** `allow_all_origins`
**Purpose:** Enable wildcard (*) for all origins
**Warning:** Cannot use with credentials

## Request Processing

### is_preflight_request
**Signature:** `is_preflight_request (a_method: STRING; a_origin: detachable STRING): BOOLEAN`
**Purpose:** Detect OPTIONS preflight request
**Logic:** Method is OPTIONS AND origin header present

### is_origin_allowed
**Signature:** `is_origin_allowed (a_origin: STRING): BOOLEAN`
**Purpose:** Check if origin is permitted
**Logic:**
1. Reject "null" origin
2. Check allow_all_origins_enabled
3. Check exact match in allowed_origins
4. Check pattern matches

## Response Generation

### headers_for_simple_request
**Signature:** `headers_for_simple_request (a_origin: STRING): HASH_TABLE [STRING, STRING]`
**Purpose:** Generate headers for non-preflight CORS request
**Headers Generated:**
- Access-Control-Allow-Origin
- Access-Control-Allow-Credentials (if enabled)
- Access-Control-Expose-Headers (if configured)
- Vary: Origin

### headers_for_preflight
**Signature:** `headers_for_preflight (a_origin, a_method: STRING; a_request_headers: detachable STRING): HASH_TABLE [STRING, STRING]`
**Purpose:** Generate headers for OPTIONS preflight
**Headers Generated:**
- Access-Control-Allow-Origin
- Access-Control-Allow-Methods
- Access-Control-Allow-Headers (if requested)
- Access-Control-Allow-Credentials (if enabled)
- Access-Control-Max-Age (if > 0)
- Vary: Origin, Access-Control-Request-Method, Access-Control-Request-Headers
