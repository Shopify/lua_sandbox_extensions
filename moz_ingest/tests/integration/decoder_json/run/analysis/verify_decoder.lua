-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

require "string"
local test = require "test_verify_message"

local messages = {
    {Logger = "foo", Type = "validated", Hostname = "example.com", Fields = {
        docVersion = 1,
        docType = "bar",
        geoCity = "Milton",
        geoCountry = "US",
        documentId = "0055FAC4-8A1A-4FCA-B380-EBFDC8571A01",
        submission = {value = [[{"exampleString":"string one"}]], value_type = 1, representation = "json"},
        user_agent_browser = "Firefox",
        user_agent_version = 59,
        user_agent_os      = "Linux"
        }
    },
    {Logger = "foo", Type = "error", Hostname = "example.com", Fields = {
        uri = "/submit/foo/bar/1/0055FAC4-8A1A-4FCA-B380-EBFDC8571A02",
        documentId = "0055FAC4-8A1A-4FCA-B380-EBFDC8571A02",
        docType = "bar",
        DecodeErrorType = "json",
        DecodeError = "invalid submission: failed to parse offset:0 Invalid value.",
        geoCity = "Milton",
        geoCountry = "US",
        docVersion = 1,
        content = ""
        }
    },
    {Logger = "foo", Type = "error", Hostname = "example.com", Fields = {
        uri = "/submit/foo/bar/1/0055FAC4-8A1A-4FCA-B380-EBFDC8571A03",
        documentId = "0055FAC4-8A1A-4FCA-B380-EBFDC8571A03",
        docType = "bar",
        DecodeErrorType = "json",
        DecodeError = "namespace: foo schema: bar version: 1 error: SchemaURI: # Keyword: required DocumentURI: #",
        geoCity = "Milton",
        geoCountry = "US",
        docVersion = 1,
        content = [[{"xString":"string one"}]]
        }
    },
    {Logger = "bar", Type = "error", Hostname = "example.com", Fields = {
        uri = "/submit/bar/bar/1/0055FAC4-8A1A-4FCA-B380-EBFDC8571A01",
        documentId = "0055FAC4-8A1A-4FCA-B380-EBFDC8571A01",
        docType = "bar",
        DecodeErrorType = "json",
        DecodeError = "namespace: bar schema: bar version: 1 error: schema not found",
        geoCity = "Milton",
        geoCountry = "US",
        docVersion = 1,
        content = "{}"
        }
    },
}

local cnt = 0
function process_message()
    cnt = cnt + 1
    local received = decode_message(read_message("raw"))
    test.fields_array_to_hash(received)
    test.verify_msg(messages[cnt], received, cnt)
    return 0
end

function timer_event(ns)
    assert(cnt == #messages, string.format("%d of %d tests ran", cnt, #messages))
end
