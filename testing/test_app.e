note
	description: "Test application for simple_cors"
	author: "Larry Rix"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests.
		do
			create tests
			print ("simple_cors test runner%N")
			print ("========================%N%N")

			passed := 0
			failed := 0

			-- Initialization
			run_test (agent tests.test_make_default, "test_make_default")
			run_test (agent tests.test_make_permissive, "test_make_permissive")
			run_test (agent tests.test_make_restrictive, "test_make_restrictive")

			-- Origin Configuration
			run_test (agent tests.test_allow_origin, "test_allow_origin")
			run_test (agent tests.test_allow_multiple_origins, "test_allow_multiple_origins")
			run_test (agent tests.test_allow_all_origins, "test_allow_all_origins")
			run_test (agent tests.test_null_origin_rejected, "test_null_origin_rejected")
			run_test (agent tests.test_origin_pattern_wildcard, "test_origin_pattern_wildcard")

			-- Method Configuration
			run_test (agent tests.test_default_methods, "test_default_methods")
			run_test (agent tests.test_allow_method, "test_allow_method")
			run_test (agent tests.test_method_case_insensitive, "test_method_case_insensitive")
			run_test (agent tests.test_allow_all_methods, "test_allow_all_methods")

			-- Header Configuration
			run_test (agent tests.test_default_headers, "test_default_headers")
			run_test (agent tests.test_allow_header, "test_allow_header")
			run_test (agent tests.test_header_case_insensitive, "test_header_case_insensitive")
			run_test (agent tests.test_are_headers_allowed, "test_are_headers_allowed")
			run_test (agent tests.test_expose_headers, "test_expose_headers")

			-- Credentials
			run_test (agent tests.test_allow_credentials, "test_allow_credentials")
			run_test (agent tests.test_credentials_disables_wildcard, "test_credentials_disables_wildcard")
			run_test (agent tests.test_disallow_credentials, "test_disallow_credentials")

			-- Request Detection
			run_test (agent tests.test_is_cors_request, "test_is_cors_request")
			run_test (agent tests.test_is_preflight_request, "test_is_preflight_request")

			-- Response Headers
			run_test (agent tests.test_simple_request_headers, "test_simple_request_headers")
			run_test (agent tests.test_simple_request_headers_wildcard, "test_simple_request_headers_wildcard")
			run_test (agent tests.test_simple_request_headers_credentials, "test_simple_request_headers_credentials")
			run_test (agent tests.test_simple_request_exposed_headers, "test_simple_request_exposed_headers")
			run_test (agent tests.test_preflight_headers, "test_preflight_headers")
			run_test (agent tests.test_preflight_max_age, "test_preflight_max_age")

			-- Max Age
			run_test (agent tests.test_set_max_age, "test_set_max_age")

			-- Edge Cases
			run_test (agent tests.test_duplicate_origin_not_added, "test_duplicate_origin_not_added")
			run_test (agent tests.test_empty_request_headers_allowed, "test_empty_request_headers_allowed")
			run_test (agent tests.test_allow_header_deduplication, "test_allow_header_deduplication")

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Implementation

	tests: LIB_TESTS

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
