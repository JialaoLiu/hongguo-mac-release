# 随包运行组件

| 组件 | 来源 | 用途 |
| --- | --- | --- |
| FqTrace / unidbg-sign | https://github.com/zhangbaio/hongguo/tree/main/unidbg-sign | 本机请求签名 |
| unidbg 与 JNI 依赖 | https://github.com/zhkl0228/unidbg | 执行签名组件所需的 native 代码 |
| OpenJDK 17 | https://openjdk.org/projects/jdk/17/ | 随包 Java 运行环境 |
| FFmpeg 与编解码库 | https://ffmpeg.org/ | CENC 媒体读取和 MP4 重封装 |

原始组件声明保存在应用的 `Contents/Resources/NativeRuntime/notices`，源码引用和构建步骤保存在本项目。Swift 界面、请求集成和本机启动器由本项目实现。

签名所需的运行资料取自 [hongguo-desktop-releases v1.0.4](https://github.com/waligoraamodio288-rgb/hongguo-desktop-releases/releases/tag/v1.0.4) 发行包。原始 Python 后端没有并入本项目。组件来源声明不代表双方存在合作或维护关系。

评论与楼中楼的协议字段参考 [fanqie-assistant/src/api/comment.ts](https://github.com/naiyQAQ/fanqie-assistant/blob/main/src/api/comment.ts)，采用独立 Swift 实现，仅接入读取接口。

应用图标根据用户提供的公开播放三角环参考，通过 imagegen 重新生成玫红至珊瑚渐变图形，保存为 `packaging/AppIcon.png`；未使用完整官方应用图标或其文字。参考形状涉及的第三方权利仍归其权利人，图标改色不表示平台授权。左上角桌面标记为本项目独立绘制的 SwiftUI 图形。本客户端为独立桌面项目。
