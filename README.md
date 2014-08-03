About this Project
==================
This is a module that implements [Yoauth](http://yoauth.herokuapp.com/) for use with [ngx_lua](http://wiki.nginx.org/HttpLuaModule). It allows you to use [Yo](http://justyo.co) to authenticate your users anywhere you would use HTTP basic auth, but with even less effort.

Installation
============
1. Have a nginx running `ngx_lua`, which you can get by following the instructions [here](http://wiki.nginx.org/HttpLuaModule#Installation).
2. Set up your lua path with dependencies. Make a directory called lua in your nginx prefix, and fill it with:
 - yoauth.lua (included)
 - dkjson.lua ([get it here](http://dkolf.de/src/dkjson-lua.fsl/home))
 - lua-resty-http ([get it here](https://github.com/liseen/lua-resty-http), copy the lib/resty directory in)
3. Ensure your nginx `lua_package_path` includes this directory (see nginx.conf.example).
4. Ensure you have a `resolver` defined (8.8.8.8 is a good choice).

Usage
=====
1. Place `access_by_lua_file "lua/yoauth.lua"` in a location block to enable Yoauth for that block.
2. Use the `X-Yoauth-Yosername` and `X-Yoauth-Id` headers to access the authenticated user's yo username and id, respectively.

Caveats
=======
- If Yoauth is down, your authenticated pages will 500.
- If you accidentally make your error pages require authentication, strange things will happen.
- This is only as secure as Yoauth, which in turn is only as secure as Yo itself.
