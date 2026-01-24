# 7S-05: SECURITY

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Security Considerations

### CORS Security Model

CORS is a security relaxation mechanism. Misconfiguration can expose APIs to unauthorized access.

### Implemented Security Measures

**1. Null Origin Rejection**
```eiffel
-- In allow_origin
require
    not_null_origin: not a_origin.same_string ("null")
```
The "null" origin is blocked because it can be spoofed in sandboxed iframes.

**2. Credentials/Wildcard Mutual Exclusion**
```eiffel
invariant
    credentials_origin_constraint: credentials_allowed implies not allow_all_origins_enabled
```
Per CORS spec, wildcard (*) cannot be used with credentials.

**3. Restrictive Default**
- `make` constructor requires explicit origin configuration
- No origins allowed until explicitly added

**4. Explicit Wildcard Acknowledgment**
- `allow_all_origins` must be called explicitly
- `make_permissive` clearly labeled for development only

### Security Recommendations

| Risk | Mitigation |
|------|------------|
| Overly permissive origins | Use explicit origin list in production |
| Credential exposure | Only enable credentials when necessary |
| Header leakage | Explicitly list exposed headers |
| Pattern matching abuse | Validate patterns carefully |

### Attack Vectors Addressed

1. **CSRF via CORS** - Origin validation prevents unauthorized requests
2. **Data exfiltration** - Header exposure control limits leaked data
3. **Cookie theft** - Credential flag requires explicit origin

### Audit Checklist

- [ ] No wildcard with credentials
- [ ] Production uses explicit origin list
- [ ] Exposed headers minimized
- [ ] Preflight caching appropriate for security needs
