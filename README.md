<p align="center">
  <img src="images/app-icon.png" width="96" alt="红果短剧应用图标" />
</p>

<h1 align="center">红果短剧</h1>

<p align="center">在 Mac 上找剧、看剧、接着看。</p>

[下载最新版本](https://github.com/JialaoLiu/hongguo-mac-release/releases/latest) · [反馈问题](https://github.com/JialaoLiu/hongguo-mac-release/issues) · [MIT License](LICENSE) · [仓库声明](REPOSITORY_NOTICE.md)

基于 SwiftUI、AppKit 与 AVFoundation 构建的 macOS 原生短剧客户端。无需安装手机端 App，找剧、选集、续播和阅读评论都在桌面完成。

**已支持深色模式、评论与楼中楼，以及相关作品和同系列其他季切换。**

## 下载与安装

在 [Releases](https://github.com/JialaoLiu/hongguo-mac-release/releases/latest) 下载 `HongguoDrama-0.4.1-arm64.dmg`，打开后将 **红果短剧.app** 拖入 Applications。

| 项目 | 要求 |
| --- | --- |
| 系统 | macOS 26 及以上 |
| 芯片 | Apple Silicon（M 系列，arm64） |
| 手机端 App | 无需安装 |
| 额外运行环境 | 无需单独安装 Java 或 FFmpeg |

### 首次打开的系统提示

当前安装包尚未完成 Apple Developer ID 签名与公证。如果出现“Apple 无法验证此应用是否安全”，将应用拖入 Applications 后尝试打开一次，关闭提示，再进入“系统设置 → 隐私与安全性”，找到红果短剧并选择“仍要打开”。仅在确认下载来源可信后操作。具体步骤见 [Apple 官方说明](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)。

运行组件已随应用提供。`hongguo-native-runtime-macos-arm64.zip` 用于维护，普通使用只需下载 DMG。

## 桌面体验

| 功能 | 使用方式 |
| --- | --- |
| 找剧 | 发现、排行榜、探索；支持真人剧、漫剧和 AI 剧 |
| 首页 | 每个区块五列两行，共十部；切换类型同步刷新热门与新剧 |
| 观看 | 点进剧集即播放；有记录从上次位置继续，无记录从第一集开始 |
| 选集与相关作品 | 完整选集，详情页可查看相关作品并直接切换同系列其他季 |
| 播放控制 | 画质、倍速、进度、音量、画中画；视频全屏平滑展开与收回 |
| 全屏手势 | 右半区双指滑动调音量，左半区调画面亮度 |
| 评论 | 未登录可只读浏览；已载入评论按点赞数降序，支持自动分页与楼中楼 |
| 收藏与历史 | 保存在本机，详情页与片单使用统一书签图标 |
| 外观 | 默认深色，支持浅色与跟随系统；玫红强调色与播放 Logo 配色一致 |

左上角只保留透明三角环 Logo，点击即可清空搜索与筛选，返回首页。排行榜与探索接近列表底部时自动批量追加作品。

## 界面预览

截图展示 0.4.1 的桌面界面。

**Discover · 深色模式**

![深色模式下的发现页，五列两行展示热门作品](images/screenshots/discover-dark.png)

**Ranking · 深色模式**

![深色模式下的排行榜](images/screenshots/ranking-dark.png)

**Explore · 浅色模式**

![浅色模式下的探索页与分类筛选](images/screenshots/explore-light.png)

## 致谢与参考

感谢以下项目及其维护者公开的代码、技术资料和产品经验，为本项目的开发提供了帮助。

| 项目 | 参考或使用范围 |
| --- | --- |
| [hongguo-desktop-releases](https://github.com/waligoraamodio288-rgb/hongguo-desktop-releases) | 桌面播放流程、功能与 Issues 的参考；签名运行资料取自其 v1.0.4 发行包 |
| [zhangbaio/hongguo](https://github.com/zhangbaio/hongguo) | 内容接口与媒体处理链路的研究资料，以及 FqTrace / unidbg-sign 运行组件 |
| [KEJIYUNB/hongguo](https://github.com/KEJIYUNB/hongguo) | Android 端交互与体验优化资料参考 |
| [fanqie-assistant](https://github.com/naiyQAQ/fanqie-assistant) | 评论、回复与楼中楼接口的协议字段参考 |
| [unidbg](https://github.com/zhkl0228/unidbg) | 本机签名组件所需的 native 执行框架 |
| [OpenJDK 17](https://openjdk.org/projects/jdk/17/) | 随包 Java 运行环境 |
| [FFmpeg](https://ffmpeg.org/) | 媒体读取、处理与 MP4 重封装 |

macOS 界面、导航、播放器交互和本机数据管理由本项目独立实现。参考资料、直接使用的组件及其原有许可分别保留，详细说明见 [THIRD_PARTY.md](THIRD_PARTY.md) 和安装包内的组件声明。

## 关于本仓库

本仓库用于发布安装包和收集反馈，应用源码保留在本地。仓库公开不代表应用完整源码已经公开。

本项目由独立开发者维护，与红果内容平台及参考项目维护者没有隶属、合作或背书关系。平台名称、商标、视频、封面和评论等内容的权利属于各自权利人。

开发者拥有权利的代码和文档采用 [MIT License](LICENSE)。第三方组件遵循各自原有许可；MIT License 不授予平台品牌或内容的使用与再分发权。发行范围和权利反馈方式见 [关于本仓库](REPOSITORY_NOTICE.md)。

## 反馈问题

欢迎在 [Issues](https://github.com/JialaoLiu/hongguo-mac-release/issues) 提交问题或建议。请附上应用版本、macOS 版本、芯片型号、复现步骤及相关截图，方便定位。
