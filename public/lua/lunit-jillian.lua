--[[--------------------------------------------------------------------------

Copyright (c) 2011, salesforce.com, inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided
that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the
following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or
promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

--]]--------------------------------------------------------------------------



--[[

      begin()
        run(testcasename, testname)
          err(fullname, message, traceback)
          fail(fullname, where, message, usermessage)
          pass(testcasename, testname)
      done()

      Fullname:
        testcase.testname
        testcase.testname:setupname
        testcase.testname:teardownname

--]]


require "lunit"

module( "lunit-jillian", package.seeall )


local function printformat(format, ...)
  print( string.format(format, ...) )
end


local columns_printed = 0

local function writestatus(char)

end


local msgs = {}


function begin()
  local total_tc = 0
  local total_tests = 0

  for tcname in lunit.testcases() do
    total_tc = total_tc + 1
    for testname, test in lunit.tests(tcname) do
      total_tests = total_tests + 1
    end
  end

  printformat("Loaded testsuite with %d tests in %d testcases.\n\n", total_tests, total_tc)
end


function run(testcasename, testname)
   printformat("Running test case %s:%s", testcasename, testname)
  -- NOP
end


function err(fullname, message, traceback)
  writestatus("E")
  msgs[#msgs+1] = "Error! ("..fullname.."):\n"..message.."\n\t"..table.concat(traceback, "\n\t") .. "\n"
end


function fail(fullname, where, message, usermessage)
  writestatus("F")
  local text =  "Failure ("..fullname.."):\n"..
                where..": "..message.."\n"

  if usermessage then
    text = text .. where..": "..usermessage.."\n"
  end

  msgs[#msgs+1] = text
end


function pass(testcasename, testname)
  writestatus(".")
end



function done()
  printformat("\n\n%d Assertions checked.\n", lunit.stats.assertions )
  print("")
  
  for i, msg in ipairs(msgs) do
    printformat( "%3d) %s\n", i, msg )
  end

  printformat("Testsuite finished (%d passed, %d failed, %d errors).\n",
      lunit.stats.passed, lunit.stats.failed, lunit.stats.errors )
end





