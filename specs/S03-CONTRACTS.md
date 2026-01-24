# S03: CONTRACTS

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Class Invariants

### SIMPLE_CORS

```eiffel
invariant
    allowed_origins_attached: allowed_origins /= Void
    allowed_methods_attached: allowed_methods /= Void
    allowed_headers_attached: allowed_headers /= Void
    exposed_headers_attached: exposed_headers /= Void
    max_age_non_negative: max_age >= 0
    credentials_origin_constraint: credentials_allowed implies not allow_all_origins_enabled
```

**Critical Invariant:**
`credentials_origin_constraint` - Enforces CORS spec requirement that wildcard (*) cannot be used with credentials.

## Feature Contracts

### allow_origin

```eiffel
require
    origin_not_void: a_origin /= Void
    origin_not_empty: not a_origin.is_empty
    not_null_origin: not a_origin.same_string ("null")
ensure
    origin_allowed: list_has_string (allowed_origins, a_origin)
    not_all_origins: not allow_all_origins_enabled
```

### allow_origin_pattern

```eiffel
require
    pattern_not_void: a_pattern /= Void
    pattern_not_empty: not a_pattern.is_empty
ensure
    pattern_added: list_has_string (origin_patterns, a_pattern)
```

### allow_credentials

```eiffel
ensure
    credentials_allowed: credentials_allowed
    not_wildcard: not allow_all_origins_enabled
```

### headers_for_simple_request

```eiffel
require
    origin_not_void: a_origin /= Void
    origin_allowed: is_origin_allowed (a_origin)
ensure
    has_origin: Result.has ("Access-Control-Allow-Origin")
    has_vary: Result.has ("Vary")
```

### headers_for_preflight

```eiffel
require
    origin_not_void: a_origin /= Void
    origin_allowed: is_origin_allowed (a_origin)
    method_not_void: a_method /= Void
    method_allowed: is_method_allowed (a_method)
    headers_allowed: a_request_headers /= Void implies are_headers_allowed (a_request_headers)
ensure
    has_origin: Result.has ("Access-Control-Allow-Origin")
    has_methods: Result.has ("Access-Control-Allow-Methods")
    has_vary: Result.has ("Vary")
```

## Contract Coverage

| Feature Type | Preconditions | Postconditions |
|--------------|---------------|----------------|
| Configuration | Yes | Yes |
| Query | Some | N/A |
| Header Generation | Strong | Strong |
