# ESP32C3-WS2812B

桌面 自定义玩具

参考资料

[原文地址](https://www.instructables.com/Lazy-Mini-Grid/)

[PlatfromIO SPIFFS第一次使用指南](https://randomnerdtutorials.com/esp32-vs-code-platformio-spiffs/)

## 3d打印模型改进 

* 灯座过于薄，容易断裂，上下两侧添加支撑
* 网格stl文件精度有点问题，打印是左侧网格走线必定会拉丝（每层都会），重新绘制复刻，并且缩短了一定的打印时间

## 代码 待优化点

json文件大小受影响开发板SPI限制，所以能小尽量小，去除没有必要的回车和空格。

动画的json数据目前遍历的形式记录，后期可以有两种方法改进：
1. 以颜色为key，坐标数组作为value进行记录
2. 背景色的灯不在进行记录，最外层表明未记录的灯的背景色值

## 开发计划

一阶段：
- ~~完成iOS自定义动画编辑功能~~
- iOS取色盘功能
- ~~iOS具备导出动画数据功能~~
- 所有硬件装机WS2812B（60灯/米规格需要1.5m）、ESP32C3
- arduino开发，读取json文件内置动画展示
- 添加蓝牙功能，快速导入动画并且展示

待排计划
- UI优化
- 小程序实现iOS编辑动画功能，进行蓝牙传输动画
- 添加WiFi实现，实现云端动画存储

优化项
- 内置电源计划（包含充电功能）
- 添加时间模块 展示时间
- 添MiniSDCard数据存储模块，实现数据存储功能（拓展内置动画展示）

## 