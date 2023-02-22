# 蓝牙协议
## 默认静态帧
|内容|长度 byte|值|含义|
|:-|:-:|:-:|:-:|
|协议头|3 |0x2b4453|默认使用0x2b4453|
|消息类型|1 |0x01| 默认静态帧|
|该条信息长度|1|1|1byte的长度|
|静态帧类型|1|n|0: 1: ...|

## 默认动画
|内容|长度 byte|值|含义|
|:-|:-:|:-:|:-:|
|协议头|3 |0x2b4453|默认使用0x2b4453|
|消息类型|2 |0x02| 默认动画|
|该条信息长度|1|1|1byte的长度|
|静态动画类型|1|n|0:哭泣脸 1: 扩散圈圈|

## 静态画面传输
|内容|长度 byte|值|含义|
|:-|:-:|:-:|:-:|
|协议头|3 |0x2b4453|默认使用0x2b4453|
|消息类型|2 |0x01| 自定义静态帧|
|是否是分割类型消息|1|0x01或者0x02|0x01单条消息, 0x02多条消息|
|信息一级标识ID|1|*|由发送端决定，请保证短期内不会重复|
|信息二级序号|1|*|从0开始|
|信息二级标识总数|1|*|--|
|该条信息长度|1|*|0-254|
|颜色数据|n|0xFFFFFF000102FF 表示FFFFFF点亮0、1、2三个灯|前3byte为对应RGB信息后每1byte代表下标位置（从0起）,直到0xFF截止开始下一段颜色标识，如此循环|