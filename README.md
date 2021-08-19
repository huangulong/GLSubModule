# 涉及到的相关知识点
1. [git submodule](https://www.cnblogs.com/gulong/p/15109271.html "历山大亚") 
   * 添加Git子模块
   * 更新Git子模块

2. [Core Data](https://www.cnblogs.com/gulong/p/15162042.html "历山大亚") 
   * 新建数据库
   * 新建表
   * 新建关系(一对多,一对一,多对一)
   * 升级数据库

3. Object-C & Swift 混编
   * OC使用Swift时, 系统会帮我们新建一个 Target-Swift.h
   * Swift使用OC时, 我们自己需要新建一个.h文件(或者在swift项目中新建一个oc的文件,
     系统会弹框提示帮我们新建一个Target-Bridging-Header.h)
     如果是我们新建文件的话 ,需要我们自己在Build Settings中设置该文件地址


注: 拉到新代码之后需要做一下操作
   $ pod install
   $ git submodule update [--remote HGLKeyPicker]  