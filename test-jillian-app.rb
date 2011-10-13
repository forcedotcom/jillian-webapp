#!/usr/bin/env ruby -rubygems

# Copyright (c) 2011, salesforce.com, inc.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, are permitted provided
# that the following conditions are met:
# 
# Redistributions of source code must retain the above copyright notice, this list of conditions and the
# following disclaimer.
# 
# Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
# the following disclaimer in the documentation and/or other materials provided with the distribution.
# 
# Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or
# promote products derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.


ENV['RACK_ENV'] = 'test'

require './jillian-app'
require 'test/unit'
require 'rack/test'

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def test_my_default
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end
  
#  def test_with_params
#    get '/meet', :name => 'Frank'
#    assert_equal 'Hello Frank!', last_response.body
#  end

  # the /install URL should not work in the browser.
  def test_install_browser
    get '/install', {}, 'HTTP_USER_AGENT' => ''
    assert_equal 404, last_response.status
  end

  def test_install_blackberry
    get '/install', {}, 'HTTP_USER_AGENT' => 'Mozilla/5.0 (BlackBerry; U; BlackBerry 9900; en) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.0.0.100 Mobile Safari/534.11+'
    assert_equal 302, last_response.status
    follow_redirect!
  end

  def test_register
    begin
      fake_device_info = {:imei => '123456',
        :model => '9876',
        :platform => 'BLACKBERRY'}
      post '/1.0/register', fake_device_info
      assert_equal 201, last_response.status
      created_deviceId = last_response.body
      device = Device.get(created_deviceId.to_i)
      assert_not_nil device
      assert_equal fake_device_info[:imei].to_i, device.imei
      assert_equal fake_device_info[:model], device.model_name
      assert_equal fake_device_info[:platform], device.platform
    ensure
      Device.destroy
    end
  end

  def test_deviceid
    begin
      fakedevice = Device.create({:imei => 12345, :platform => 'FakeCo.'})
      assert fakedevice.saved?
      assert !fakedevice.dirty?
      post '/1.0/deviceid', {:imei => '12345'}
      assert_equal 200, last_response.status
      assert_equal fakedevice.id, last_response.body.to_i
    ensure
      Device.destroy
    end
  end

  def test_log
    begin
      fakebody = "a device log."
      fakedevice = Device.create({:imei => 12345, :platform => 'FakeCo.'})
      assert fakedevice.saved?
      assert !fakedevice.dirty?
      post '/1.0/log', fakebody, {'HTTP_DEVICEID' => fakedevice.id.to_s}
      assert_equal 201, last_response.status
      assert_equal 1, fakedevice.deviceLogs.length
      log = fakedevice.deviceLogs[0]
      assert_not_nil log, "log is null"
      assert_equal fakebody, log.body
    ensure
      Device.destroy
      DeviceLog.destroy
    end
  end
end
