
do 
    local proto = Proto('redis', 'Redis')

    local f = proto.fields
    
    f.value   = ProtoField.string('redis.value',   'Value')

    function proto.dissector(buffer, pinfo, tree)
        pinfo.cols.protocol = 'Redis'

		local matches = buffer():string():gmatch('[^\r\n]+')
        local offset = 0
		local length = buffer:len()
		local matches = buffer():string():gmatch('[^\r\n]+')
		local child = tree:add(proto, buffer(offset, length),'Redis Buffer')
		for line in matches do
			child:add('', line)
		end
	end

    -- register this dissector for the standard Redis ports
    local dissectors = DissectorTable.get('tcp.port')
    for _, port in ipairs{ 6379, } do
        dissectors:add(port, proto)
    end
end
