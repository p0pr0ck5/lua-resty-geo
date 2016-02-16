#lua-resty-geo

Lightweight module to mimic ngx_http_geo_module

##Status

This library is in active development and is production ready.

##Dependencies

This library makes use of the [lua-resty-iputils](https://github.com/hamishforbes/lua-resty-iputils) library.

##Synopsis

```lua
	http {
		init_by_lua '
			local geo = require "resty.geo"

			geo.default("foo")
			geo.cidr("127.0.0.0/24", "bar")
			geo.cidr("192.168.0.0/16", "baz")
		';
	}

	server {
		location / {
			content_by_lua '
				local geo = require "resty.geo"

				-- re-define a cidr if its value will change per request
				geo.cidr("10.0.0.0/8", ngx.var.http_x_forwarded_for, true)

				local value = geo.exec(ngx.var.remote_addr)

				ngx.say(value)
			';
		}
	}
```

##Functions

###geo.default(value)

Define the default value for geo to return if no CIDRs match.

###geo.enable_iputils_cache(size?)

Enable the LRU cache for `lua-resty-iputils`. This is just a wrapper for the `iputils` call.

###geo.cidr(cidr, value, override?)

Define a CIDR block and the value to return if the CIDR matches. If you want to update the value of the CIDR entry on each request (e.g. outside of the `init_by_lua` phase), you must specify the `override` value as `true`. This is useful when you want to return a per-request variable, such as an `ngx.var` entry.

###License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>

###Bugs

Please report bugs by creating a ticket with the GitHub issue tracker.

