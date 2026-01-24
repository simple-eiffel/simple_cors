# S05: CONSTRAINTS

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Technical Constraints

### CORS Specification Constraints

| Constraint | Enforcement | Reason |
|------------|-------------|--------|
| No wildcard with credentials | Invariant | CORS spec requirement |
| Null origin blocked | Precondition | Security (spoofable) |
| Vary header required | Postcondition | Caching correctness |

### Data Constraints

| Field | Constraint | Enforcement |
|-------|------------|-------------|
| allowed_origins | Not Void | Invariant |
| allowed_methods | Not Void | Invariant |
| allowed_headers | Not Void | Invariant |
| max_age | >= 0 | Invariant |

### Input Constraints

| Feature | Constraint |
|---------|------------|
| allow_origin | Not empty, not "null" |
| allow_origin_pattern | Not empty |
| allow_method | Not empty |
| allow_header | Not empty |
| set_max_age | Non-negative |

## Behavioral Constraints

### Mutual Exclusion

1. **Credentials vs Wildcard**
   - If credentials_allowed, then not allow_all_origins_enabled
   - allow_credentials automatically disables wildcard

2. **Explicit vs Wildcard**
   - allow_origin disables allow_all_origins_enabled
   - Explicit origins take precedence

### Header Generation Rules

1. **Origin Header**
   - Wildcard mode + no credentials = "*"
   - Otherwise = echo requested origin

2. **Methods Header**
   - Wildcard methods mode = echo requested method
   - Otherwise = list all allowed methods

3. **Headers Header**
   - Only included if headers were requested in preflight

## Performance Constraints

- Origin matching: O(n) in allowed origins + patterns
- Header validation: O(n*m) for n headers, m allowed
- Memory: Proportional to configured lists
