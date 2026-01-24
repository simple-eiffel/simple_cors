# S06: BOUNDARIES

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## System Boundaries

### Internal Boundaries

```
+------------------+
|   SIMPLE_CORS    |
|------------------|
| Origin Mgmt      |
| Method Mgmt      |
| Header Mgmt      |
| Credentials      |
| Header Gen       |
+------------------+
```

Single class encapsulates all CORS functionality.

### External Boundaries

```
+-------------+     +---------------+     +-------------+
| HTTP Server | --> | SIMPLE_CORS   | --> | HTTP        |
| (request)   |     | (validation & |     | Response    |
|             |     |  header gen)  |     | (headers)   |
+-------------+     +---------------+     +-------------+
```

### Integration Points

| Integration | Direction | Data |
|-------------|-----------|------|
| HTTP Server | Input | Origin header, method |
| HTTP Server | Input | Access-Control-Request-* |
| HTTP Response | Output | HASH_TABLE of headers |

## Responsibilities

### SIMPLE_CORS Responsibilities
- Validate origins against configuration
- Validate methods against configuration
- Validate headers against configuration
- Generate appropriate CORS response headers
- Enforce CORS specification rules

### Caller Responsibilities
- Extract Origin header from request
- Extract Access-Control-Request-* headers
- Detect request type (OPTIONS vs regular)
- Apply generated headers to response
- Set appropriate response status code

## Not Responsible For

- HTTP request parsing
- HTTP response sending
- Session management
- Authentication
- Request routing
- Logging/auditing
