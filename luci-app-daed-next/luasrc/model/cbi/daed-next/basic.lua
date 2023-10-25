local m, s

m = Map("daed-next", translate("DAE Dashboard"))
m.description = translate("A Linux high-performance transparent proxy solution based on eBPF")

m:section(SimpleSection).template = "daed-next/daed-next_status"

s = m:section(TypedSection, "daed-next")
s.addremove = false
s.anonymous = true

if nixio.fs.stat("/sys/fs/bpf","type") ~= "dir" then
	s.rawhtml = true
	s.template = "daed-next/daed-next_error"
end

o = s:option(Flag, "enabled", translate("Enabled"))
o.rmempty = false

o = s:option(Value, "listen_port", translate("Web Listen port"))
o.datatype = "and(port,min(1))"
o.default = 3000

o = s:option(Flag, "log_enabled", translate("Enable Logs"))
o.default = 0
o.rmempty = false

o = s:option(Value, "log_maxbackups", translate("Logfile retention count"))
o.default = 1
o:depends("log_enabled", "1")

o = s:option(Value, "log_maxsize", translate("Logfile Max Size (MB)"))
o.default = 1
o:depends("log_enabled", "1")

return m
