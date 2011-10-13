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

require 'sinatra'
require 'sinatra/content_for'
require 'sass'
require 'erb'
require 'haml'
require 'data_mapper'
require 'dm-validations'
require 'logger'
require 'active_support'

api_version = '1.0'

logger = Logger.new(STDOUT)



logger = Logger.new(STDOUT)

configure :production do
DataMapper.setup(:default, ENV['DATABASE_URL'])


end

configure :test do 
  DataMapper::Logger.new($stdout, :debug)
  puts 'Test configuration in use' 
  DataMapper.setup(:default, "sqlite3::memory:") 
end 

configure :development do 
  DataMapper::Logger.new($stdout, :debug)
  puts 'Development configuration in use' 
DataMapper.setup(:default, 'sqlite3://' + File.expand_path('development.db', File.dirname(__FILE__)))
end

require './models'

configure do
  enable :logging
  mime_type :jad, 'text/vnd.sun.j2me.app-descriptor'
end

#logger = Logger.new(STDERR)

# Quick test
get '/' do
  @title = 'Welcome to Jack'
  haml :index
end

get '/devices/?' do
  @devices = Device.all(:order => [:imei.asc])
  logger.info "there are #{@devices.inspect} devices"
  haml :device_list
end

get '/device/:deviceid' do
  @device = Device.get(params[:deviceid])
  logger.info "showing detail for #{@device}"
  haml :device_detail
end

get '/log/:devicelogid' do
  @devicelog = DeviceLog.get(params[:devicelogid])
  @device = @devicelog.device
  haml :log_detail
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss :stylesheet
end

get '/install' do
  agent = request.user_agent
  logger.info "user agent: '#{agent}'"
  if agent[/(BlackBerry)/]
    redirect to('/apps/blackberry/jillian.jad')
  end
  status 404
  body "Couldn't detect your mobile device type. Your User-Agent is: <tt>#{agent}</tt>"
end

## LUA preprocessor (erb)
get '/luac' do
  filename = params[:t]
  filepath = '../public/lua/' + filename + '.lua'
  logger.info "Preprocessing #{filename} (#{filepath})"

  erb filepath.to_sym
end

## API Methods


# Post a log file to be persisted.
# Header['DEVICEID'] is the primary key to the devices table. if you don't know your pkid, see the /deviceid service.
# Body: the body to post.
# Returns: 201 on success.
post '/'+ api_version + '/log' do
  deviceid = env['HTTP_DEVICEID']
  logger.info "Receiving log for device id '#{deviceid}'"
  if deviceid == 0
    logger.error "cannot find device id. #{request.inspect}"
    status 500 and return
  end
  request.body.rewind  # in case someone already read it

  device = Device.get(deviceid)
  logger.info "found device #{device}"
  log = DeviceLog.create(:created_at => Time.now,
                         :body => request.body.read,
                         :device => device)
  if not log.saved?
    logger.error "cannot save log" 
    log.errors.each do |e|
      logger.error "cannot save log. Validation failure: #{e}"
    end
    status 500 and return
  end
  status 201
end

# (re-)Register a device in the inventory.
post '/' + api_version + '/register' do
  logger.info params
  device = Device.first_or_create({:imei => params[:imei]},
                                 {:created_at => Time.now,
                                   :model_name => params[:model],
                                   :platform => params[:platform]})
  logger.info "found Device: #{device.id}, imei=#{device.imei}, saved=#{device.saved?}"
  device.update(:os_version => params[:os_version])
  #if @device.saved?
  status 201
  body device.id.to_s
  #else
  #  status 500
  #end
end

# Get the device's primary key into the Devices table.
# POST paramter: 'imei' is an integer for the IMEI (optional)
# POST parameter: 'esn' is a decimal for the ESN (optional)
# RETURN: status 200 and the body is the primary key. If the device isn't found, status 404 is returned.
post '/' + api_version + '/deviceid' do
  imei = params[:imei]
  logger.info "Looking for device with IMEI #{imei}"
  @device = Device.first({:imei => imei})
  logger.info "found: #{@device}"
  if @device
    status 200
    body @device.id.to_s
  else
    status 404
  end
end

# Test at <appname>.heroku.com

# You can see all your app specific information this way.
# IMPORTANT! This is a very bad thing to do for a production
# application with sensitive information

# get '/env' do
# ENV.inspect
# end
