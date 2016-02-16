local _M = {}

_M.verison = "0.1"

local iputils = require "iputils"
local bit     = require "bit"
local bor     = bit.bor
local tobit   = bit.tobit
local lshift  = bit.lshift
local byte    = string.byte

local default
local cidr_mapping = {}

function _M.default(value)
	default = value
end

function _M.cidr(cidr, value, override)
	local lower, upper = iputils.parse_cidr(cidr)

	if (override or not cidr_mapping[cidr]) then
		cidr_mapping[cidr] = { { lower, upper }, value }
	end
end

function _M.enable_iputils_cache(size)
	iputils.enable_lrucache(size)
end

function _M.exec(ip, bin)
	local bin_ip

	if (bin) then
		bin_ip = 0
		for i= 1, 4 do
			bin_ip = bor(lshift(bin_ip, 8), tobit(byte(ip, i)))
		end
	else
		bin_ip = iputils.ip2bin(ip)
	end

	for k, v in pairs(cidr_mapping) do
		local pair = cidr_mapping[k]
		local cidr, value = pair[1], pair[2]

		if bin_ip >= cidr[1] and bin_ip <= cidr[2] then
			return value
		end
	end

	return default
end

return _M
