-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

require "string"
local test = require "test_verify_message"

local messages = {
    {
        Timestamp = 1518636021000000000,
        Logger = "input.grammar_args",
        Hostname = "ubuntu",
        Payload = 'foo=bar a=14 baz="hello kitty" cool%story=bro f %^asdf ip=216.160.83.56',
        Pid = 3453,
        Fields = {
            programname = "someapp",
            real_hostname = "www.example.com"
        }
    }
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
