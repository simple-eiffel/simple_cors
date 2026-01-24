# S02: CLASS CATALOG

**Library:** simple_cors
**Date:** 2026-01-23
**Status:** BACKWASH (reverse-engineered from implementation)

## Class Overview

| Class | Purpose | LOC |
|-------|---------|-----|
| SIMPLE_CORS | CORS header generation and validation | 633 |

## SIMPLE_CORS

### Description
Main class implementing Cross-Origin Resource Sharing (CORS) header generation following the Fetch Standard.

### Inheritance
- Inherits: ANY (default)

### Creation Procedures
| Name | Purpose |
|------|---------|
| make | Default initialization (secure) |
| make_permissive | Development mode (allow all) |
| make_restrictive | Production mode (deny all) |

### Feature Groups

**Origin Configuration**
- allow_origin, allow_origins
- allow_origin_pattern
- allow_all_origins, disallow_all_origins

**Method Configuration**
- allow_method, allow_methods
- allow_all_methods

**Header Configuration**
- allow_header, allow_headers
- allow_all_headers
- expose_header, expose_headers

**Credentials Configuration**
- allow_credentials
- disallow_credentials

**Cache Configuration**
- set_max_age

**Request Processing**
- is_cors_request
- is_preflight_request
- is_origin_allowed
- is_method_allowed
- is_header_allowed
- are_headers_allowed

**Response Header Generation**
- headers_for_simple_request
- headers_for_preflight

**Query Attributes**
- allowed_origins, allowed_methods, allowed_headers
- exposed_headers, credentials_allowed, max_age
- allow_all_origins_enabled, allow_all_methods_enabled
- allow_all_headers_enabled

### Constants
| Name | Value | Purpose |
|------|-------|---------|
| Default_max_age | 86400 | 24-hour preflight cache |
