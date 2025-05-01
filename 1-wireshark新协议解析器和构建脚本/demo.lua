local demo = Proto('demo', 'Demo Protocol')
Trans_ID = ProtoField.uint16("demo.ID","ID")  -- 定义协议字段和长度，16bit
Msg_Type = ProtoField.uint16("demo.Type","Type")  -- 定义协议字段和长度，16bit
Msg_Data = ProtoField.uint32("demo.Data","Data")  -- 定义协议字段和长度，32bit

demo.fields = {Trans_ID,Msg_Type,Msg_Data}  -- 合并字段

function demo.dissector(tvb,pinfo,tree)
    pinfo.cols.protocol = demo.name  -- 获取协议名词
    local subtree = tree:add(demo,tvb(0))  -- 添加树状新节点
    subtree:add(Trans_ID,tvb(0,2))  -- 添加协议解析树，0开始，偏移2字节
    subtree:add(Msg_Type,tvb(2,2))  -- 添加协议解析树，2开始，偏移2字节
    subtree:add(Msg_Data,tvb(4,4))  -- 添加协议解析树，4开始，偏移4字节
end
DissectorTable.get('tcp.port'):add(10002,demo)