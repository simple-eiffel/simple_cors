note
	description: "CORS (Cross-Origin Resource Sharing) support following the Fetch Standard"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Fetch Standard CORS", "protocol=URI", "src=https://fetch.spec.whatwg.org/#http-cors-protocol"

class
	SIMPLE_CORS

create
	make,
	make_permissive,
	make_restrictive

feature {NONE} -- Initialization

	make
			-- Create with sensible defaults (no origins allowed, must be configured).
		do
			create allowed_origins.make (5)
			create allowed_methods.make (5)
			create allowed_headers.make (10)
			create exposed_headers.make (5)
			create origin_patterns.make (3)

			-- Default allowed methods (simple methods per CORS spec)
			allowed_methods.extend ("GET")
			allowed_methods.extend ("HEAD")
			allowed_methods.extend ("POST")

			-- Default allowed headers (simple headers per CORS spec)
			allowed_headers.extend ("accept")
			allowed_headers.extend ("accept-language")
			allowed_headers.extend ("content-language")
			allowed_headers.extend ("content-type")

			credentials_allowed := False
			max_age := Default_max_age
		ensure
			no_origins_allowed: allowed_origins.is_empty
			has_default_methods: not allowed_methods.is_empty
			credentials_not_allowed: not credentials_allowed
		end

	make_permissive
			-- Create with permissive settings for development.
			-- Allows all origins, methods, and common headers.
		do
			make
			allow_all_origins_enabled := True
			allow_all_methods
			allow_all_headers
		ensure
			all_origins_allowed: allow_all_origins_enabled
		end

	make_restrictive
			-- Create with restrictive settings for production.
			-- Nothing allowed until explicitly configured.
		do
			create allowed_origins.make (5)
			create allowed_methods.make (5)
			create allowed_headers.make (10)
			create exposed_headers.make (5)
			create origin_patterns.make (3)
			credentials_allowed := False
			max_age := Default_max_age
		ensure
			no_origins: allowed_origins.is_empty
			no_methods: allowed_methods.is_empty
			no_headers: allowed_headers.is_empty
		end

feature -- Origin Configuration

	allow_origin (a_origin: STRING)
			-- Add `a_origin` to allowed origins list.
			-- Origin must be exact (e.g., "https://example.com").
		require
			origin_not_void: a_origin /= Void
			origin_not_empty: not a_origin.is_empty
			not_null_origin: not a_origin.same_string ("null")
		do
			if not list_has_string (allowed_origins, a_origin) then
				allowed_origins.extend (a_origin)
			end
			allow_all_origins_enabled := False
		ensure
			origin_allowed: list_has_string (allowed_origins, a_origin)
			not_all_origins: not allow_all_origins_enabled
		end

	allow_origins (a_list: ARRAY [STRING])
			-- Add multiple origins to allowed list.
		require
			list_not_void: a_list /= Void
		local
			i: INTEGER
		do
			from
				i := a_list.lower
			until
				i > a_list.upper
			loop
				if attached a_list [i] as l_origin and then not l_origin.is_empty then
					allow_origin (l_origin)
				end
				i := i + 1
			variant
				a_list.upper - i + 1
			end
		end

	allow_origin_pattern (a_pattern: STRING)
			-- Add a regex pattern for origin matching.
			-- Use with caution to avoid security issues.
		require
			pattern_not_void: a_pattern /= Void
			pattern_not_empty: not a_pattern.is_empty
		do
			if not list_has_string (origin_patterns, a_pattern) then
				origin_patterns.extend (a_pattern)
			end
		ensure
			pattern_added: list_has_string (origin_patterns, a_pattern)
		end

	allow_all_origins
			-- Allow any origin (use "*" header).
			-- Warning: Cannot be used with credentials.
		do
			allow_all_origins_enabled := True
		ensure
			all_origins_allowed: allow_all_origins_enabled
		end

	disallow_all_origins
			-- Disable allow-all-origins mode.
		do
			allow_all_origins_enabled := False
		ensure
			not_all_origins: not allow_all_origins_enabled
		end

feature -- Method Configuration

	allow_method (a_method: STRING)
			-- Add `a_method` to allowed methods.
		require
			method_not_void: a_method /= Void
			method_not_empty: not a_method.is_empty
		local
			l_upper: STRING
		do
			l_upper := a_method.as_upper
			if not list_has_string (allowed_methods, l_upper) then
				allowed_methods.extend (l_upper)
			end
		ensure
			method_allowed: list_has_string (allowed_methods, a_method.as_upper)
		end

	allow_methods (a_list: ARRAY [STRING])
			-- Add multiple methods to allowed list.
		require
			list_not_void: a_list /= Void
		local
			i: INTEGER
		do
			from
				i := a_list.lower
			until
				i > a_list.upper
			loop
				if attached a_list [i] as l_method then
					allow_method (l_method)
				end
				i := i + 1
			variant
				a_list.upper - i + 1
			end
		end

	allow_all_methods
			-- Allow all common HTTP methods.
		do
			allowed_methods.wipe_out
			allowed_methods.extend ("GET")
			allowed_methods.extend ("HEAD")
			allowed_methods.extend ("POST")
			allowed_methods.extend ("PUT")
			allowed_methods.extend ("DELETE")
			allowed_methods.extend ("PATCH")
			allowed_methods.extend ("OPTIONS")
			allow_all_methods_enabled := True
		ensure
			flag_set: allow_all_methods_enabled
		end

feature -- Header Configuration

	allow_header (a_header: STRING)
			-- Add `a_header` to allowed headers (case-insensitive).
		require
			header_not_void: a_header /= Void
			header_not_empty: not a_header.is_empty
		local
			l_lower: STRING
		do
			l_lower := a_header.as_lower
			if not list_has_string (allowed_headers, l_lower) then
				allowed_headers.extend (l_lower)
			end
		ensure
			header_allowed: list_has_string (allowed_headers, a_header.as_lower)
		end

	allow_headers (a_list: ARRAY [STRING])
			-- Add multiple headers to allowed list.
		require
			list_not_void: a_list /= Void
		local
			i: INTEGER
		do
			from
				i := a_list.lower
			until
				i > a_list.upper
			loop
				if attached a_list [i] as l_header then
					allow_header (l_header)
				end
				i := i + 1
			variant
				a_list.upper - i + 1
			end
		end

	allow_all_headers
			-- Allow any request header.
		do
			allow_all_headers_enabled := True
		ensure
			all_headers_allowed: allow_all_headers_enabled
		end

	expose_header (a_header: STRING)
			-- Expose `a_header` to JavaScript (via Access-Control-Expose-Headers).
		require
			header_not_void: a_header /= Void
			header_not_empty: not a_header.is_empty
		local
			l_lower: STRING
		do
			l_lower := a_header.as_lower
			if not list_has_string (exposed_headers, l_lower) then
				exposed_headers.extend (l_lower)
			end
		ensure
			header_exposed: list_has_string (exposed_headers, a_header.as_lower)
		end

	expose_headers (a_list: ARRAY [STRING])
			-- Expose multiple headers.
		require
			list_not_void: a_list /= Void
		local
			i: INTEGER
		do
			from
				i := a_list.lower
			until
				i > a_list.upper
			loop
				if attached a_list [i] as l_header then
					expose_header (l_header)
				end
				i := i + 1
			variant
				a_list.upper - i + 1
			end
		end

feature -- Credentials Configuration

	allow_credentials
			-- Allow credentials (cookies, authorization headers).
			-- Note: Cannot be used with wildcard origin "*".
		do
			credentials_allowed := True
			-- Disable wildcard when credentials enabled
			if allow_all_origins_enabled then
				allow_all_origins_enabled := False
			end
		ensure
			credentials_allowed: credentials_allowed
			not_wildcard: not allow_all_origins_enabled
		end

	disallow_credentials
			-- Disallow credentials.
		do
			credentials_allowed := False
		ensure
			credentials_not_allowed: not credentials_allowed
		end

feature -- Cache Configuration

	set_max_age (a_seconds: INTEGER)
			-- Set preflight cache duration in seconds.
		require
			non_negative: a_seconds >= 0
		do
			max_age := a_seconds
		ensure
			max_age_set: max_age = a_seconds
		end

feature -- Request Processing

	is_cors_request (a_origin: detachable STRING): BOOLEAN
			-- Is this a CORS request (has Origin header)?
		do
			Result := a_origin /= Void and then not a_origin.is_empty
		end

	is_preflight_request (a_method: STRING; a_origin: detachable STRING): BOOLEAN
			-- Is this a CORS preflight request?
			-- Preflight uses OPTIONS with Origin header.
		do
			Result := a_method /= Void and then
				a_method.same_string ("OPTIONS") and then
				is_cors_request (a_origin)
		end

	is_origin_allowed (a_origin: STRING): BOOLEAN
			-- Is `a_origin` in the allowed list?
		require
			origin_not_void: a_origin /= Void
		local
			i: INTEGER
		do
			-- Never allow null origin (security risk)
			if a_origin.same_string ("null") then
				Result := False
			elseif allow_all_origins_enabled then
				Result := True
			elseif list_has_string (allowed_origins, a_origin) then
				Result := True
			else
				-- Check patterns
				from
					i := 1
				until
					i > origin_patterns.count or Result
				loop
					Result := origin_matches_pattern (a_origin, origin_patterns [i])
					i := i + 1
				variant
					origin_patterns.count - i + 1
				end
			end
		end

	is_method_allowed (a_method: STRING): BOOLEAN
			-- Is `a_method` allowed?
		require
			method_not_void: a_method /= Void
		do
			if allow_all_methods_enabled then
				Result := True
			else
				Result := list_has_string (allowed_methods, a_method.as_upper)
			end
		end

	is_header_allowed (a_header: STRING): BOOLEAN
			-- Is `a_header` allowed?
		require
			header_not_void: a_header /= Void
		do
			if allow_all_headers_enabled then
				Result := True
			else
				Result := list_has_string (allowed_headers, a_header.as_lower)
			end
		end

	are_headers_allowed (a_headers: STRING): BOOLEAN
			-- Are all headers in comma-separated `a_headers` allowed?
		require
			headers_not_void: a_headers /= Void
		local
			l_parts: LIST [STRING]
			l_header: STRING
		do
			if a_headers.is_empty then
				Result := True
			else
				Result := True
				l_parts := a_headers.split (',')
				from
					l_parts.start
				until
					l_parts.after or not Result
				loop
					l_header := l_parts.item
					l_header.adjust
					if not l_header.is_empty then
						Result := is_header_allowed (l_header)
					end
					l_parts.forth
				end
			end
		end

feature -- Response Header Generation

	headers_for_simple_request (a_origin: STRING): HASH_TABLE [STRING, STRING]
			-- Generate CORS headers for a simple (non-preflight) request.
		require
			origin_not_void: a_origin /= Void
			origin_allowed: is_origin_allowed (a_origin)
		do
			create Result.make (5)

			-- Access-Control-Allow-Origin
			if allow_all_origins_enabled and not credentials_allowed then
				Result.put ("*", "Access-Control-Allow-Origin")
			else
				Result.put (a_origin, "Access-Control-Allow-Origin")
			end

			-- Access-Control-Allow-Credentials
			if credentials_allowed then
				Result.put ("true", "Access-Control-Allow-Credentials")
			end

			-- Access-Control-Expose-Headers
			if not exposed_headers.is_empty then
				Result.put (headers_as_string (exposed_headers), "Access-Control-Expose-Headers")
			end

			-- Vary header (important for caching)
			Result.put ("Origin", "Vary")
		ensure
			has_origin: Result.has ("Access-Control-Allow-Origin")
			has_vary: Result.has ("Vary")
		end

	headers_for_preflight (a_origin: STRING; a_method: STRING; a_request_headers: detachable STRING): HASH_TABLE [STRING, STRING]
			-- Generate CORS headers for a preflight OPTIONS request.
		require
			origin_not_void: a_origin /= Void
			origin_allowed: is_origin_allowed (a_origin)
			method_not_void: a_method /= Void
			method_allowed: is_method_allowed (a_method)
			headers_allowed: a_request_headers /= Void implies are_headers_allowed (a_request_headers)
		do
			create Result.make (7)

			-- Access-Control-Allow-Origin
			if allow_all_origins_enabled and not credentials_allowed then
				Result.put ("*", "Access-Control-Allow-Origin")
			else
				Result.put (a_origin, "Access-Control-Allow-Origin")
			end

			-- Access-Control-Allow-Methods
			if allow_all_methods_enabled then
				Result.put (a_method, "Access-Control-Allow-Methods")
			else
				Result.put (methods_as_string, "Access-Control-Allow-Methods")
			end

			-- Access-Control-Allow-Headers
			if a_request_headers /= Void and then not a_request_headers.is_empty then
				if allow_all_headers_enabled then
					Result.put (a_request_headers, "Access-Control-Allow-Headers")
				else
					Result.put (headers_as_string (allowed_headers), "Access-Control-Allow-Headers")
				end
			end

			-- Access-Control-Allow-Credentials
			if credentials_allowed then
				Result.put ("true", "Access-Control-Allow-Credentials")
			end

			-- Access-Control-Max-Age
			if max_age > 0 then
				Result.put (max_age.out, "Access-Control-Max-Age")
			end

			-- Vary header
			Result.put ("Origin, Access-Control-Request-Method, Access-Control-Request-Headers", "Vary")
		ensure
			has_origin: Result.has ("Access-Control-Allow-Origin")
			has_methods: Result.has ("Access-Control-Allow-Methods")
			has_vary: Result.has ("Vary")
		end

feature -- Query

	allowed_origins: ARRAYED_LIST [STRING]
			-- List of allowed origins.

	allowed_methods: ARRAYED_LIST [STRING]
			-- List of allowed HTTP methods.

	allowed_headers: ARRAYED_LIST [STRING]
			-- List of allowed request headers.

	exposed_headers: ARRAYED_LIST [STRING]
			-- List of headers exposed to JavaScript.

	credentials_allowed: BOOLEAN
			-- Are credentials allowed?

	max_age: INTEGER
			-- Preflight cache duration in seconds.

	allow_all_origins_enabled: BOOLEAN
			-- Is wildcard origin mode enabled?

	allow_all_methods_enabled: BOOLEAN
			-- Are all methods allowed?

	allow_all_headers_enabled: BOOLEAN
			-- Are all headers allowed?

feature -- Constants

	Default_max_age: INTEGER = 86400
			-- Default preflight cache: 24 hours.

feature {NONE} -- Implementation

	origin_patterns: ARRAYED_LIST [STRING]
			-- Regex patterns for origin matching.

	origin_matches_pattern (a_origin, a_pattern: STRING): BOOLEAN
			-- Does `a_origin` match `a_pattern`?
			-- Simple wildcard matching: * matches any sequence.
		require
			origin_not_void: a_origin /= Void
			pattern_not_void: a_pattern /= Void
		local
			l_pattern: STRING
			l_parts: LIST [STRING]
			l_pos: INTEGER
			l_part: STRING
		do
			if a_pattern.same_string ("*") then
				Result := True
			elseif not a_pattern.has ('*') then
				Result := a_origin.same_string (a_pattern)
			else
				-- Simple wildcard matching
				l_pattern := a_pattern.twin
				l_parts := l_pattern.split ('*')
				l_pos := 1
				Result := True

				from
					l_parts.start
				until
					l_parts.after or not Result
				loop
					l_part := l_parts.item
					if not l_part.is_empty then
						l_pos := a_origin.substring_index (l_part, l_pos)
						if l_pos = 0 then
							Result := False
						else
							l_pos := l_pos + l_part.count
						end
					end
					l_parts.forth
				end
			end
		end

	methods_as_string: STRING
			-- Allowed methods as comma-separated string.
		do
			create Result.make (50)
			across allowed_methods as m loop
				if not Result.is_empty then
					Result.append (", ")
				end
				Result.append (m)
			end
		end

	headers_as_string (a_list: ARRAYED_LIST [STRING]): STRING
			-- Headers list as comma-separated string.
		require
			list_not_void: a_list /= Void
		do
			create Result.make (100)
			across a_list as h loop
				if not Result.is_empty then
					Result.append (", ")
				end
				Result.append (h)
			end
		end

	list_has_string (a_list: ARRAYED_LIST [STRING]; a_string: STRING): BOOLEAN
			-- Does `a_list` contain a string equal to `a_string`?
		require
			list_not_void: a_list /= Void
			string_not_void: a_string /= Void
		do
			across a_list as item loop
				if item.same_string (a_string) then
					Result := True
				end
			end
		end

invariant
	allowed_origins_attached: allowed_origins /= Void
	allowed_methods_attached: allowed_methods /= Void
	allowed_headers_attached: allowed_headers /= Void
	exposed_headers_attached: exposed_headers /= Void
	max_age_non_negative: max_age >= 0
	credentials_origin_constraint: credentials_allowed implies not allow_all_origins_enabled

end
