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


--- Navigation (trackpad) event
-- @param dx (Integer) Scroll in the left-right direction. Negative is left, positive is right.
-- @param dy (Integer) Scroll in the up-down direction. Negative is up, positive is down.
function navEvent(dx, dy)
   local eventClick = 6914
   local eventUnclick = 6915
   local eventMove = 6913
   injector.navigationevent(eventMove, dx, dy, 0)
   platform.sleep(100)
end

function navClick()
   local eventClick = 6914
   local eventUnclick = 6915
   injector.navigationevent(eventClick, 0, 0, 0)
   injector.navigationevent(eventUnclick, 0, 0, 0)
   platform.sleep(100)
end

function touchEvent(x1, y1)
   local touchDown = 13569
   local touchUp = 13570
   local touchMove = 13571
   local touchClick = 13573
   local touchUnclick = 13574
   injector.touchevent(touchClick, x1, y1, -1, -1, 0)
end


function keyEvent(str)
   injector.keyevent(str)
end

-- some key constants (use with injector.keycodeevent(ddd))
-- (from Keypad.class)
KEY_BACKSPACE     = 008
KEY_ENTER         = 013
KEY_ESCAPE        = 027
KEY_SPEAKERPHONE  = 273
KEY_SEND          = 017
KEY_END           = 018
KEY_CONVENIENCE_1 = 019
KEY_CONVENIENCE_2 = 021
KEY_MENU          = 4098

--- Bring up the BlackBerry Menu
function keyMenu()
   injector.keycodeevent(KEY_MENU)
end

--- Press the "Return", "Back", or "Escape" key (all the same button)
function keyBack()
   injector.keycodeevent(KEY_BACKSPACE)
end

ACCESSIBLE_ROLE_SCREEN       =  1
ACCESSIBLE_ROLE_TEXT_FIELD   =  2
ACCESSIBLE_ROLE_MENU_ITEM    =  3
ACCESSIBLE_ROLE_MENU         =  4
ACCESSIBLE_ROLE_APP_ICON     =  5
ACCESSIBLE_ROLE_PUSH_BUTTON  =  6
ACCESSIBLE_ROLE_DIALOG       =  7
ACCESSIBLE_ROLE_CHECKBOX     =  8
ACCESSIBLE_ROLE_DATE         =  9
ACCESSIBLE_ROLE_PASSWORD     = 10
ACCESSIBLE_ROLE_RADIO_BUTTON = 11
ACCESSIBLE_ROLE_COMBO        = 12
ACCESSIBLE_ROLE_CHOICE       = 13
ACCESSIBLE_ROLE_HYPERLINK    = 14
ACCESSIBLE_ROLE_ICON         = 15
ACCESSIBLE_ROLE_LABEL        = 16
ACCESSIBLE_ROLE_GAUGE        = 17
ACCESSIBLE_ROLE_HINT_POPUP   = 18
ACCESSIBLE_ROLE_CHART        = 19
ACCESSIBLE_ROLE_SYMBOL       = 22
ACCESSIBLE_ROLE_BITMAP       = 23
ACCESSIBLE_ROLE_SEPARATOR    = 24
ACCESSIBLE_ROLE_LIST         = 25
ACCESSIBLE_ROLE_TREE_FIELD   = 26
ACCESSIBLE_ROLE_PANEL        = 27
ACCESSIBLE_ROLE_DATE_FIELD   = 28
ACCESSIBLE_ROLE_TABLE        = 29
ACCESSIBLE_ROLE_TAB          = 30

--- Wait for a specific accessibility role/name to appear.
-- This is a blocking function.
-- @param role (Integer) One of ACCESSIBLE_ROLE_*.
-- @param name (String) AccessibleName of the AccessibleContext
-- @param timeout How long to wait, measured in milliseconds. Default is 5000.
function waitFor(role, name, timeout)
   timeout = timeout or 5000
   local countdown = 10
   local a = injector.inspectscreen(role)
   while (countdown >= 0 and (a.accessibleName ~= name)) do
      print ("looking for " .. name, a.accessibleRole, a.accessibleName)
      print (a)
      platform.sleep(500)
      countdown = countdown - 500
      a = injector.inspectscreen(role)
   end
   assert(countdown > 0, "cannot find '" .. name .. "'")
end

--- Go to the BlackBerry home screen.
-- If the home screen cannot be found, an error is thrown.
function goToHome()
   local a = injector.inspectscreen(ACCESSIBLE_ROLE_SCREEN)
   local countdown = 10
   while (countdown >= 0 and (a.accessibleName ~= "Home Screen")) do
      print (a.accessibleRole, a.accessibleName)
      injector.keyevent(ESCAPE)
      platform.sleep(100)
      countdown = countdown - 1
      a = injector.inspectscreen(ACCESSIBLE_ROLE_SCREEN)
   end
   assert(countdown > 0, "cannot close to home screen")
end

--- Find a menu item by label.
-- The menu should already be open.
-- If the menu is not found, or there are duplicate menus next to each other, an error is thrown.
-- @param label (String) The menu label
-- @param sleep (Int) Sleep time during navigation, measured in milliseconds. The default value is 1000. Optional.
function findMenu(label, sleep)
   sleep = sleep or 1000
   navEvent(0, -20) -- scroll up
   a = injector.inspectscreen()
   assert(a.accessibleRole == ACCESSIBLE_ROLE_MENU_ITEM or a.accessibleRole == ACCESSIBLE_ROLE_MENU,
          "Accessible item is not a MENU or MENU_ITEM (" .. a.accessibleRole .. ")")
   countdown = 20
   while (countdown >= 0 and a.accessibleName ~= label) do
      platform.sleep(1000)
      navEvent(0, 1)
      b = injector.inspectscreen(ACCESSIBLE_ROLE_MENU_ITEM)
      print ("looking for", a.accessibleName, "found:", b.accessibleName)
      if (b.accessibleName == a.accessibleName) then
         error("Duplicate menus:" .. a.accessibleName)
      end
      a = b
      countdown = countdown - 1 -- decrement the safety countdown.
   end
   assert(countdown > 0, "cannot find menu:" .. label)
end

--- Shortcut to print the inspected screen
-- @param role (Int) Optional. Represents an accessible role. See ACCESSIBLE_ROLE_*
function is(role)
   print (injector.inspectscreen(role))
end

function dumpall()
   for i=1,30,1 do
      pcall(function ()
               print (injector.inspectscreen(i))
            end
         )
   end
end

