<p align="center">
  <img src="images/app-icon.png" width="96" alt="红果短剧应用图标" />
</p>

<h1 align="center">红果短剧</h1>

<p align="center">Mac 上点进就播，下次回来接着看。</p>

[![Release](https://img.shields.io/github/v/release/JialaoLiu/hongguo-mac-release?label=release&color=ff1f8c)](https://github.com/JialaoLiu/hongguo-mac-release/releases/latest)
[![Build](https://img.shields.io/badge/build-macOS%2026%2B%20arm64-303036)](https://github.com/JialaoLiu/hongguo-mac-release/releases/latest)

**不用手机 App，不用另装 Java、FFmpeg 或 Homebrew。** 找剧、选集、续播、看评论，在一个桌面窗口里完成。

[下载安装包](https://github.com/JialaoLiu/hongguo-mac-release/releases/latest) · [反馈问题](https://github.com/JialaoLiu/hongguo-mac-release/issues) · [使用许可](LICENSE) · [项目声明](REPOSITORY_NOTICE.md)

## 一条命令，装好就看

支持 **Apple Silicon（M 系列）和 macOS 26 及以上**。打开终端，粘贴这条命令：

```bash
curl -fsSL https://raw.githubusercontent.com/JialaoLiu/hongguo-mac-release/main/install.sh | bash
```

自动下载最新版、安装到 Applications、检查签名完整性。装好后打开 **红果短剧** 即可；无需单独下载运行组件 ZIP。运行前可先查看 [脚本内容](install.sh)。

**Discover · 深色模式**

![发现页，五列两行展示热门作品](images/screenshots/discover-dark.png)

## 看剧顺手，找剧省事

| 想做什么 | 直接怎么用 |
| --- | --- |
| 找一部剧 | 搜索剧名或演员，切换真人剧、漫剧、AI 剧 |
| 不知道看什么 | 看热播榜、刷发现页，探索里按主题筛选 |
| 接着上次看 | 点进剧集就续播；没看过的从第一集开始 |
| 找下一季 | 在相关作品里直接切换同系列其他季 |
| 边做事边看 | 开画中画，或切换视频全屏 |
| 调整播放 | 选画质、调倍速、拖进度；全屏左侧调亮度，右侧调音量 |
| 看大家怎么说 | 读评论、看点赞数、展开楼中楼；下滑自动加载 |
| 留着以后看 | 收藏和观看记录保存在本机 |
| 换个外观 | 默认深色，也支持浅色和跟随系统 |

排行榜与探索下滑自动追加，不用反复点“加载更多”。左上角 Logo 一点，就回首页。

<details>
<summary>更多界面：Ranking 与 Explore</summary>

**Ranking · 深色模式**

![深色模式下的排行榜](images/screenshots/ranking-dark.png)

**Explore · 浅色模式**

![浅色模式下的探索与分类筛选](images/screenshots/explore-light.png)

</details>

## 想手动安装？

在 [Releases](https://github.com/JialaoLiu/hongguo-mac-release/releases/latest) 下载最新的 `HongguoDrama-<版本>-arm64.dmg`，打开后把 **红果短剧.app** 拖到右侧 **Applications**。

<details>
<summary>手动安装后的首次打开提示，以及指定版本安装</summary>

当前安装包使用 ad hoc 签名，尚未完成 Apple Developer ID 签名与公证。手动下载后若提示“Apple 无法验证此应用是否安全”：

1. 将应用拖到 Applications，尝试打开一次，关闭提示。
2. 打开“系统设置 → 隐私与安全性”。
3. 找到红果短剧，选择“仍要打开”。

macOS 15 及以后，右键“打开”已不能绕过这个提示。[Apple 官方步骤](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)

确认来源可信后，也可以在终端运行：

```bash
xattr -dr com.apple.quarantine "/Applications/红果短剧.app"
```

一键安装脚本已包含清除该应用下载隔离属性的步骤。这不代表应用已获 Apple 公证。

安装指定版本：

```bash
curl -fsSL https://raw.githubusercontent.com/JialaoLiu/hongguo-mac-release/main/install.sh | HONGGUO_VERSION=0.4.1 bash
```

</details>

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

## 用途与版权

本项目面向个人学习、研究和技术交流，是独立维护的非官方客户端，与红果平台没有隶属或合作关系。

新发布且明确采用 [非商业使用许可](LICENSE) 的自有材料，**请勿商用**。平台名称、商标、视频、封面、评论和第三方组件的权利归各自权利方所有；本项目许可不授予第三方内容的使用权。

源码保留在本地，公开仓库用于发行和反馈。详细说明见 [项目声明](REPOSITORY_NOTICE.md)。

<details>
<summary>历史版本的许可</summary>

v0.4.2 及此前已发布的安装包继续使用各自随包许可。此前按 MIT 授予的权利不会因这次声明更新而取消；后续采用非商业许可的安装包须随包提供新许可。

</details>

## 用着顺手，欢迎点个 Star

问题和建议发到 [Issues](https://github.com/JialaoLiu/hongguo-mac-release/issues)。带上应用版本、macOS 版本和截图，方便定位。
