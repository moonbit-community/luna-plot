# Luna Plot

Luna Plot 是一个基于 MoonBit 的数据可视化库，专注于提供简洁、高效的图表绘制功能。

## 功能特性

快速绘制多种函数图形。插入便捷标签。覆盖坐标轴。

## 配置依赖运行示例

使用 MoonBit 包管理器安装：

```bash
moon add Kaida-Amethyst/math
moon add moonbitlang/x
```
## 快捷启动
运行./build.sh。若要自行编译，请取消第一行注释。并且更改native-zig的编译路径为自身路径（用别的后端编译也可以）：
```src/main/moon.pkg.json]
"link": {
    "native": {
      "flags": [
        "-cc",
        "/D/zig/zig.exe cc -target riscv64-linux-musl -O2 -static"
        //这里改为自己的zig路径
      ]
    }
  }
```
## 示例
具体代码详见src/main/main.mbt。以下给出图片示例：
![函数图像示例](./example1.png)
![函数图像示例](./example2.png)
