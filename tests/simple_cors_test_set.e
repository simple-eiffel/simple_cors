note
	description: "Tests for SIMPLE_CORS"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	SIMPLE_CORS_TEST_SET

inherit
	TEST_SET_BASE

feature -- Test: Initialization

	test_make_default
			-- Test default initialization.
		note
			testing: "covers/{SIMPLE_CORS}.make"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			assert_true ("no origins by default", cors.allowed_origins.is_empty)
			assert_false ("credentials not allowed", cors.credentials_allowed)
			assert_false ("not all origins", cors.allow_all_origins_enabled)
			assert_integers_equal ("default max age", 86400, cors.max_age)
		end

	test_make_permissive
			-- Test permissive initialization.
		note
			testing: "covers/{SIMPLE_CORS}.make_permissive"
		local
			cors: SIMPLE_CORS
		do
			create cors.make_permissive
			assert_true ("all origins enabled", cors.allow_all_origins_enabled)
			assert_true ("all headers enabled", cors.allow_all_headers_enabled)
			assert_true ("all methods enabled", cors.allow_all_methods_enabled)
		end

	test_make_restrictive
			-- Test restrictive initialization.
		note
			testing: "covers/{SIMPLE_CORS}.make_restrictive"
		local
			cors: SIMPLE_CORS
		do
			create cors.make_restrictive
			assert_true ("no origins", cors.allowed_origins.is_empty)
			assert_true ("no methods", cors.allowed_methods.is_empty)
			assert_true ("no headers", cors.allowed_headers.is_empty)
		end

feature -- Test: Origin Configuration

	test_allow_origin
			-- Test adding a single origin.
		note
			testing: "covers/{SIMPLE_CORS}.allow_origin"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_origin ("https://example.com")
			assert_integers_equal ("origin added", 1, cors.allowed_origins.count)
			assert_true ("origin is allowed", cors.is_origin_allowed ("https://example.com"))
		end

	test_allow_multiple_origins
			-- Test adding multiple origins.
		note
			testing: "covers/{SIMPLE_CORS}.allow_origins"
		local
			cors: SIMPLE_CORS
			origins: ARRAY [STRING]
		do
			create cors.make
			origins := <<"https://example.com", "https://api.example.com", "https://other.com">>
			cors.allow_origins (origins)
			assert_integers_equal ("three origins", 3, cors.allowed_origins.count)
			assert_true ("first allowed", cors.is_origin_allowed ("https://example.com"))
			assert_true ("second allowed", cors.is_origin_allowed ("https://api.example.com"))
			assert_true ("third allowed", cors.is_origin_allowed ("https://other.com"))
		end

	test_allow_all_origins
			-- Test wildcard origin mode.
		note
			testing: "covers/{SIMPLE_CORS}.allow_all_origins"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_all_origins
			assert_true ("all origins flag", cors.allow_all_origins_enabled)
			assert_true ("any origin allowed", cors.is_origin_allowed ("https://random.com"))
		end

	test_null_origin_rejected
			-- Test that null origin is always rejected.
		note
			testing: "covers/{SIMPLE_CORS}.is_origin_allowed"
		local
			cors: SIMPLE_CORS
		do
			create cors.make_permissive
			assert_false ("null origin rejected", cors.is_origin_allowed ("null"))
		end

	test_origin_pattern_wildcard
			-- Test pattern matching with wildcards.
		note
			testing: "covers/{SIMPLE_CORS}.allow_origin_pattern"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_origin_pattern ("https://*.example.com")
			assert_true ("subdomain matches", cors.is_origin_allowed ("https://api.example.com"))
			assert_true ("www matches", cors.is_origin_allowed ("https://www.example.com"))
			assert_false ("different domain", cors.is_origin_allowed ("https://example.org"))
		end

feature -- Test: Method Configuration

	test_default_methods
			-- Test default allowed methods.
		note
			testing: "covers/{SIMPLE_CORS}.make"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			assert_true ("GET allowed", cors.is_method_allowed ("GET"))
			assert_true ("HEAD allowed", cors.is_method_allowed ("HEAD"))
			assert_true ("POST allowed", cors.is_method_allowed ("POST"))
			assert_false ("PUT not allowed", cors.is_method_allowed ("PUT"))
			assert_false ("DELETE not allowed", cors.is_method_allowed ("DELETE"))
		end

	test_allow_method
			-- Test adding a method.
		note
			testing: "covers/{SIMPLE_CORS}.allow_method"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_method ("PUT")
			assert_true ("PUT allowed", cors.is_method_allowed ("PUT"))
		end

	test_method_case_insensitive
			-- Test method matching is case-insensitive.
		note
			testing: "covers/{SIMPLE_CORS}.is_method_allowed"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_method ("put")
			assert_true ("lowercase put", cors.is_method_allowed ("put"))
			assert_true ("uppercase PUT", cors.is_method_allowed ("PUT"))
			assert_true ("mixed Put", cors.is_method_allowed ("Put"))
		end

	test_allow_all_methods
			-- Test allowing all methods.
		note
			testing: "covers/{SIMPLE_CORS}.allow_all_methods"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_all_methods
			assert_true ("all methods flag", cors.allow_all_methods_enabled)
			assert_true ("PATCH allowed", cors.is_method_allowed ("PATCH"))
			assert_true ("OPTIONS allowed", cors.is_method_allowed ("OPTIONS"))
		end

feature -- Test: Header Configuration

	test_default_headers
			-- Test default allowed headers.
		note
			testing: "covers/{SIMPLE_CORS}.make"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			assert_true ("accept allowed", cors.is_header_allowed ("Accept"))
			assert_true ("content-type allowed", cors.is_header_allowed ("Content-Type"))
			assert_false ("authorization not allowed", cors.is_header_allowed ("Authorization"))
		end

	test_allow_header
			-- Test adding a header.
		note
			testing: "covers/{SIMPLE_CORS}.allow_header"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_header ("Authorization")
			assert_true ("authorization allowed", cors.is_header_allowed ("Authorization"))
		end

	test_header_case_insensitive
			-- Test header matching is case-insensitive.
		note
			testing: "covers/{SIMPLE_CORS}.is_header_allowed"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_header ("X-Custom-Header")
			assert_true ("original case", cors.is_header_allowed ("X-Custom-Header"))
			assert_true ("lowercase", cors.is_header_allowed ("x-custom-header"))
			assert_true ("uppercase", cors.is_header_allowed ("X-CUSTOM-HEADER"))
		end

	test_are_headers_allowed
			-- Test checking multiple headers.
		note
			testing: "covers/{SIMPLE_CORS}.are_headers_allowed"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_header ("Authorization")
			cors.allow_header ("X-Custom")
			assert_true ("both allowed", cors.are_headers_allowed ("Authorization, X-Custom"))
			assert_false ("one not allowed", cors.are_headers_allowed ("Authorization, X-Forbidden"))
		end

	test_expose_headers
			-- Test exposing headers.
		note
			testing: "covers/{SIMPLE_CORS}.expose_header"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.expose_header ("X-Request-Id")
			cors.expose_header ("X-Rate-Limit")
			assert_integers_equal ("two exposed", 2, cors.exposed_headers.count)
		end

feature -- Test: Credentials Configuration

	test_allow_credentials
			-- Test enabling credentials.
		note
			testing: "covers/{SIMPLE_CORS}.allow_credentials"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_origin ("https://example.com")
			cors.allow_credentials
			assert_true ("credentials allowed", cors.credentials_allowed)
		end

	test_credentials_disables_wildcard
			-- Test that enabling credentials disables wildcard origin.
		note
			testing: "covers/{SIMPLE_CORS}.allow_credentials"
		local
			cors: SIMPLE_CORS
		do
			create cors.make_permissive
			assert_true ("wildcard before", cors.allow_all_origins_enabled)
			cors.allow_credentials
			assert_false ("wildcard disabled", cors.allow_all_origins_enabled)
		end

	test_disallow_credentials
			-- Test disabling credentials.
		note
			testing: "covers/{SIMPLE_CORS}.disallow_credentials"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_credentials
			cors.disallow_credentials
			assert_false ("credentials disabled", cors.credentials_allowed)
		end

feature -- Test: Request Detection

	test_is_cors_request
			-- Test CORS request detection.
		note
			testing: "covers/{SIMPLE_CORS}.is_cors_request"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			assert_true ("has origin", cors.is_cors_request ("https://example.com"))
			assert_false ("no origin", cors.is_cors_request (Void))
			assert_false ("empty origin", cors.is_cors_request (""))
		end

	test_is_preflight_request
			-- Test preflight request detection.
		note
			testing: "covers/{SIMPLE_CORS}.is_preflight_request"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			assert_true ("OPTIONS with origin", cors.is_preflight_request ("OPTIONS", "https://example.com"))
			assert_false ("GET with origin", cors.is_preflight_request ("GET", "https://example.com"))
			assert_false ("OPTIONS no origin", cors.is_preflight_request ("OPTIONS", Void))
		end

feature -- Test: Response Headers

	test_simple_request_headers
			-- Test headers for simple request.
		note
			testing: "covers/{SIMPLE_CORS}.headers_for_simple_request"
		local
			cors: SIMPLE_CORS
			headers: HASH_TABLE [STRING, STRING]
		do
			create cors.make
			cors.allow_origin ("https://example.com")
			headers := cors.headers_for_simple_request ("https://example.com")

			assert_true ("has allow-origin", headers.has ("Access-Control-Allow-Origin"))
			if attached headers ["Access-Control-Allow-Origin"] as l_origin then
				assert_strings_equal ("origin echoed", "https://example.com", l_origin)
			end
			assert_true ("has vary", headers.has ("Vary"))
			if attached headers ["Vary"] as l_vary then
				assert_strings_equal ("vary origin", "Origin", l_vary)
			end
		end

	test_simple_request_headers_wildcard
			-- Test headers with wildcard origin.
		note
			testing: "covers/{SIMPLE_CORS}.headers_for_simple_request"
		local
			cors: SIMPLE_CORS
			headers: HASH_TABLE [STRING, STRING]
		do
			create cors.make_permissive
			headers := cors.headers_for_simple_request ("https://example.com")
			if attached headers ["Access-Control-Allow-Origin"] as l_origin then
				assert_strings_equal ("wildcard origin", "*", l_origin)
			end
		end

	test_simple_request_headers_credentials
			-- Test headers with credentials.
		note
			testing: "covers/{SIMPLE_CORS}.headers_for_simple_request"
		local
			cors: SIMPLE_CORS
			headers: HASH_TABLE [STRING, STRING]
		do
			create cors.make
			cors.allow_origin ("https://example.com")
			cors.allow_credentials
			headers := cors.headers_for_simple_request ("https://example.com")

			assert_true ("has credentials", headers.has ("Access-Control-Allow-Credentials"))
			if attached headers ["Access-Control-Allow-Credentials"] as l_creds then
				assert_strings_equal ("credentials true", "true", l_creds)
			end
			-- With credentials, origin should be echoed not *
			if attached headers ["Access-Control-Allow-Origin"] as l_origin then
				assert_strings_equal ("specific origin", "https://example.com", l_origin)
			end
		end

	test_simple_request_exposed_headers
			-- Test exposed headers in response.
		note
			testing: "covers/{SIMPLE_CORS}.headers_for_simple_request"
		local
			cors: SIMPLE_CORS
			headers: HASH_TABLE [STRING, STRING]
		do
			create cors.make
			cors.allow_origin ("https://example.com")
			cors.expose_header ("X-Request-Id")
			cors.expose_header ("X-Rate-Limit")
			headers := cors.headers_for_simple_request ("https://example.com")

			assert_true ("has expose", headers.has ("Access-Control-Expose-Headers"))
			if attached headers ["Access-Control-Expose-Headers"] as l_exposed then
				assert_string_contains ("has request-id", l_exposed, "x-request-id")
			end
		end

	test_preflight_headers
			-- Test headers for preflight request.
		note
			testing: "covers/{SIMPLE_CORS}.headers_for_preflight"
		local
			cors: SIMPLE_CORS
			headers: HASH_TABLE [STRING, STRING]
		do
			create cors.make
			cors.allow_origin ("https://example.com")
			cors.allow_method ("PUT")
			cors.allow_header ("Authorization")
			headers := cors.headers_for_preflight ("https://example.com", "PUT", "Authorization")

			assert_true ("has allow-origin", headers.has ("Access-Control-Allow-Origin"))
			assert_true ("has allow-methods", headers.has ("Access-Control-Allow-Methods"))
			assert_true ("has allow-headers", headers.has ("Access-Control-Allow-Headers"))
			assert_true ("has vary", headers.has ("Vary"))
		end

	test_preflight_max_age
			-- Test max-age in preflight response.
		note
			testing: "covers/{SIMPLE_CORS}.headers_for_preflight"
		local
			cors: SIMPLE_CORS
			headers: HASH_TABLE [STRING, STRING]
		do
			create cors.make
			cors.allow_origin ("https://example.com")
			cors.set_max_age (3600)
			headers := cors.headers_for_preflight ("https://example.com", "GET", Void)

			assert_true ("has max-age", headers.has ("Access-Control-Max-Age"))
			if attached headers ["Access-Control-Max-Age"] as l_max_age then
				assert_strings_equal ("max-age value", "3600", l_max_age)
			end
		end

feature -- Test: Max Age

	test_set_max_age
			-- Test setting max age.
		note
			testing: "covers/{SIMPLE_CORS}.set_max_age"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.set_max_age (7200)
			assert_integers_equal ("max age set", 7200, cors.max_age)
		end

feature -- Test: Edge Cases

	test_duplicate_origin_not_added
			-- Test that duplicate origins aren't added.
		note
			testing: "covers/{SIMPLE_CORS}.allow_origin"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			cors.allow_origin ("https://example.com")
			cors.allow_origin ("https://example.com")
			assert_integers_equal ("only one", 1, cors.allowed_origins.count)
		end

	test_empty_request_headers_allowed
			-- Test empty access-control-request-headers.
		note
			testing: "covers/{SIMPLE_CORS}.are_headers_allowed"
		local
			cors: SIMPLE_CORS
		do
			create cors.make
			assert_true ("empty headers ok", cors.are_headers_allowed (""))
		end

	test_allow_header_deduplication
			-- Test that duplicate headers aren't added.
		note
			testing: "covers/{SIMPLE_CORS}.allow_header"
		local
			cors: SIMPLE_CORS
			initial_count: INTEGER
		do
			create cors.make
			initial_count := cors.allowed_headers.count
			cors.allow_header ("X-Custom")
			cors.allow_header ("x-custom")  -- Same header, different case
			assert_integers_equal ("only one added", initial_count + 1, cors.allowed_headers.count)
		end

end
