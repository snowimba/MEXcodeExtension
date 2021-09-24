# MEXcodeExtension
Xcode 的一些实用插件
用 OC 和 swift 分别写了两个插件，方便大家参考。

1. 可以一键对引入的文件进行排序。

2. 可以一键删除空白行空格。

遇到问题欢迎提 issue。

下载项目后，先编译一遍，然后可以在 product 文件夹下面看到生成的 .app 文件。

右键 show in finder 拷贝到 Mac 的应用程序文件。

然后双击打开一次，去系统偏好设置里面找到扩展，找到 Xcode Source Editor 

（如果找不到这个选项可以先把 Xcode 完全关掉，改掉 Xcode.app 的名字，如：Xcoda。然后在去扩展里面找这个选项，有了后可以改回 Xcode 的名字）

选择对应的插件打钩，重启 Xcode。

在 Xcode Editor 里面可以看到对应的插件。去 Xcode —> 偏好设置 —> key bindings 里面为插件设置快捷键，就可以实现一键操作了。

## 版本更新
### 1.1（2）
增加 XcodeKit 库，使 Editor 支持显示扩展功能

如果之前已安装，按照下述步骤更新，如果未安装，参考上面步骤。
**Mac 更新扩展步骤：**
1. 打开系统偏好设置 --> 扩展，取消勾选 MEXcodeExtension 下的选项
2. 打开文件面板，在应用程序中删除 MEXcodeExtension
3. 将编译好的 MEXcodeExtension 重新拖进应用程序
4. 打开系统偏好设置 --> 扩展，勾选 MEXcodeExtension 下的选项
此时，在 Xcode Editor 的下拉菜单中可看到扩展功能
