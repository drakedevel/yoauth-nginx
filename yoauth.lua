local http = require("resty.http")
local json = require("dkjson")

local args = ngx.req.get_uri_args()
if args["yoauth_token"] == nil then
   -- Initial request, redirect to Yoauth authentication flow
   local url
   if ngx.var.ssl_protocol ~= nil then
      url = "https://"
   else
      url = "http://"
   end
   url = url .. ngx.var.http_host .. ngx.var.uri
   return ngx.redirect("https://yoauth.herokuapp.com/authorize?redirect_to="..url,
                       ngx.HTTP_MOVED_TEMPORARILY)
elseif args["yoauth_token"] == "test" then
   -- Yoauth will validate the test token to BILAWALHAMEED
   return ngx.exit(ngx.HTTP_UNAUTHORIZED)
else
   -- We got a callback, validate cookie and set headers appropriately
   local hc = http:new()
   local ok, code, headers, status, body = hc:request { 
      method = "GET",
      url = "https://yoauth.herokuapp.com/validate?yoauth_token=" .. args["yoauth_token"]
   }
   
   if not ok then
      return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
   end
      
   local blob, pos, err = json.decode(body)
   if err then
      return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
   end

   if blob["status"] == "OK" then
      ngx.req.set_header("x-yoauth-yosername", blob["user"]["yo_username"])
      ngx.req.set_header("x-yoauth-id", blob["user"]["id"])
   else
      return ngx.exit(ngx.HTTP_UNAUTHORIZED)
   end
end
