Jillian-webapp
==============

This is the complimentary web service for using [Jillian](https://github.com/forcedotcom/jillian). It serves up
`.lua` files that can be executed by Jillian.

Running
-------

    bundle install
    rackup -p 4567
    open http://localhost:4567/

Dependencies
------------
These are all declared in the `Gemfile`.

Sinatra: [BSD license](https://github.com/sinatra/sinatra/blob/master/LICENSE)
Sinatra-content-for: [BSD License](https://github.com/foca/sinatra-content-for/blob/master/LICENSE)
SASS: [MIT license](http://sass-lang.com/docs/yardoc/file.MIT-LICENSE.html)
ERB (built in to Ruby) [license](http://www.ruby-lang.org/en/LICENSE.txt)
HAML: [MIT license](http://haml-lang.com/docs/yardoc/file.MIT-LICENSE.html)
DataMapper, DataMapper Validations: [BSD license](https://github.com/datamapper/dm-core/blob/master/LICENSE)
ActiveSupport: [MIT license](http://as.rubyonrails.org/files/README.html)
Lunit: [MIT license](http://repo.or.cz/w/lunit.git/blob/HEAD:/LICENSE)
LICENSE
-------
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

NOTE from salesforce.com: This tool depends on separately distributed software which may be subject
to different license terms and be copyrighted by authors other than salesforce.com. Please review
the list of dependencies and make sure these license terms are acceptable before downloading this
tool.
