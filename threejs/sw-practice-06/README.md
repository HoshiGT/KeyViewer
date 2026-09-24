# SolidWorks 竞赛练习题（6）· three.js 模型

按 [机械时代网教程](http://www.jxage.com/11706.html) 的 9 个特征步骤，用 three.js 和 [three-bvh-csg](https://github.com/gkjohnson/three-bvh-csg) 布尔运算重建的零件。

直接用浏览器打开 `index.html` 即可（three.js 从 jsDelivr 加载，需要联网）。

- 左侧特征树可以回退到任意一步，`←` / `→` 切换
- 视图：等轴测 / 前视 / 上视 / 后视，支持沿上视基准面剖切
- 边线是屏幕空间描边（法线 + 深度），不依赖网格拓扑
