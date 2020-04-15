# MEXcodeExtension
Xcode 的一些实用插件
用OC和swift分别写了两个插件，方便大家参考。
1.可以一键对引入的文件进行排序。
2.可以一键删除多余的空格。
遇到问题欢迎提issue。

下载项目后，先编译一遍，然后可以在product文件加下面看到生成的.app文件，
右键 show in finder 拷贝到Mac的应用程序文件，
然后双击打开一次，去系统偏好设置里面找到扩展，找到 Xcode Source Editor （如果找不到这个选项可以先把Xcode完全关掉，改掉 Xcode.app 的名字，如：Xcoda，然后在去扩展里面找这个选项，有了后可以改回 Xcode 的名字）选择对应的插件打钩，重启 Xcode。
在 Xcode Editor 里面可以看到对应的插件。去 Xcode —> 偏好设置 —> key bindings 里面为插件设置快捷键，就可以实现一键操作了。
