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

require 'data_mapper'


class Device
  include DataMapper::Resource
  
  property :id,         Serial    # An auto-increment integer key
  property :imei,       String, :unique => true, :format => /\d{15,16}/
  property :platform, String, :required => true #eg. BLACKBERRY, IOS, ANDROID
  
  property :model_name,      String
  property :created_at, DateTime  # A DateTime, for any date you might like.
  property :os_version, String #todo format validation
  has n, :deviceLogs

  #TODO
  #validates_with_method :check_imei_checkdigit
  def check_imei_checkdigit
    # Luhn check digit if this is a 15-character IMEI
    if (self.imei.length == 15)
      total = 0
      for i in (self.imei.length .. 0)
        v = self.imei[i].to_i
        if (i % 2 == 0)
          total += v
        else
          total += v*2
        end
      end
      if (total % 10 == 0)
        return true
      else
        return [false, "IMEI check digit failed. Not a valid IMEI"]
      end
    else
      return true
    end
  end
end

class DeviceLog
  include DataMapper::Resource

  property :id,         Serial
  property :created_at, DateTime, :required => true
  property :body,       Text

  belongs_to :device
end

# must be the end of the models:

# keep your data:
DataMapper.finalize.auto_upgrade!

# start from scratch:
#DataMapper.finalize.auto_migrate!
