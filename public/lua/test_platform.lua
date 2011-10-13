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

require "lunit"

module ("platform", package.seeall, lunit.testcase)

function assertFunctionExists(t, functionName)
   assert_table(t)
   assert_function(t[functionName], "function doesn't exist: '" .. functionName .. "'")
end

function assertFunctionReturnType(f, functionName, expectedType) 
   assert_equal(expectedType, type(f()), "function '" .. functionName .. "' return type is wrong. Expected " .. expectedType)
end

function test_platform()
   assert_table(platform, "'platform' module doesn't exist")
   local p = _G['platform']
   assertFunctionExists(p, 'sleep')
   assertFunctionExists(p, 'inform')
   assertFunctionExists(p, 'imei')
   assertFunctionExists(p, 'devicepin')
   assertFunctionExists(p, 'devicename')
   assertFunctionExists(p, 'deviceosversion')
   assertFunctionExists(p, 'platformName')
   assertFunctionExists(p, 'getApplicationInfo')
   assertFunctionExists(p, 'isSimulator')
   assertFunctionExists(p, 'batteryLevel')
   assertFunctionReturnType(platform.imei, 'imei', 'string')
end

function test_navigation()
   assert_table(injector, "'injector' module doesn't exist")
   assert (_G['injector'] and type(_G['injector']) == 'table', "injector table doesn't exist")
   local n = _G['injector']
   assertFunctionExists(n, 'keyevent')
   assertFunctionExists(n, 'keycodeevent')
   assertFunctionExists(n, 'navigationevent')
   assertFunctionExists(n, 'touchevent')
   assertFunctionExists(n, 'inspectfield')
   assertFunctionExists(n, 'inspectscreen')
end