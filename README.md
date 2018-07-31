# 气泡选择框

# 使用方法
``` swift
let configure = PXPullConfigure()
configure.apexPoint = CGPoint(x: UIScreen.main.bounds.width - 45, y: 45)
let view = PXPullView.init(configure: configure, titileArr: ["测试1","测试2","测试3","测试4","测试5"])
        view.show()
```
> configure为view的配置参数，apexPoint为三角的顶点位置，可选的配置参数如下
``` swift
class PXPullConfigure {
    var width: CGFloat = 100
    var height: CGFloat = 200
    var apexPoint: CGPoint = CGPoint(x: 0, y: 0) //三角顶点
    var scale: CGFloat = 0.25 //以箭头为界 小边和长边的比例
    var fillColor: UIColor = UIColor.white //填充颜色
    var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.25) //遮罩颜色
    var shadowFatherView: UIView = UIApplication.shared.keyWindow! //添加的view
}
```
对于越界的配置参数进行了处理，默认距离父View的`内边距为16`
``` swift
        if configure.width > UIScreen.main.bounds.width/2 {
            configure.width = UIScreen.main.bounds.width/2
        }
        if configure.height > UIScreen.main.bounds.height/2 {
            configure.height = UIScreen.main.bounds.height/2
        }
        if configure.scale >= 1 {
            configure.scale = 0.25
        }
```
``` swift
        if self.configure.apexPoint.x == UIScreen.main.bounds.width/2 {
            //btn在屏幕中间
            orginX = (UIScreen.main.bounds.width - configure.width)/2
        }else if self.configure.apexPoint.x < UIScreen.main.bounds.width/2{
            //btn在屏幕左边
            orginX = self.configure.apexPoint.x - configure.width * configure.scale
            if orginX < 16 {
                //左边界超出界面
                orginX = 16
            }
        }else if self.configure.apexPoint.x > UIScreen.main.bounds.width/2{
            //btn在屏幕右边
            orginX = self.configure.apexPoint.x + configure.width * (1 - configure.scale)
            if orginX + configure.width > UIScreen.main.bounds.width - 16 {
                //右边界超出界面
                orginX = UIScreen.main.bounds.width - 16 - configure.width
            }
        }
``` 
# 效果图如下
![效果图](https://upload-images.jianshu.io/upload_images/2260856-bb1c072222fbc6c9.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 [GitHub地址](超链接地址 "https://github.com/px123zx/PXPullView")
✨期待你们的小星星
