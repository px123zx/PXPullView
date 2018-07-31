//
//  PXPullView.swift
//  PullMenuView
//
//  Created by Paxton on 2018/7/31.
//  Copyright © 2018年 px. All rights reserved.
//

import UIKit

class PXPullConfigure {
    var width: CGFloat = 100
    var height: CGFloat = 200
    var apexPoint: CGPoint = CGPoint(x: 0, y: 0) //三角顶点
    var scale: CGFloat = 0.25 //以箭头为界 小边和长边的比例
    var fillColor: UIColor = UIColor.white //填充颜色
    var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.25) //遮罩颜色
    var shadowFatherView: UIView = UIApplication.shared.keyWindow! //添加的view
}


protocol PXPullViewDelegate {
    func pullView(_ pullView: PXPullView, didSelectRowAt index: Int, title: String)
}

class PXPullView: UIView {
    let configure: PXPullConfigure!
    let triangleCenterX: CGFloat
    var titileArr: [String]?
    var delegate: PXPullViewDelegate?
    
    private override init(frame: CGRect) {
        self.configure = PXPullConfigure()
        self.triangleCenterX = 0
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    convenience init(configure: PXPullConfigure, titileArr: [String]){
        self.init(configure: configure)
        self.titileArr = titileArr
        //减去三角高度 圆角高度
        let tableView = UITableView(frame: CGRect(x: 0, y: 11, width: self.bounds.width, height: self.bounds.height - 16))
        tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.addSubview(tableView)
    }
    
    
    private init(configure: PXPullConfigure){
        self.configure = configure
        
        if configure.width > UIScreen.main.bounds.width/2 {
            configure.width = UIScreen.main.bounds.width/2
        }
        if configure.height > UIScreen.main.bounds.height/2 {
            configure.height = UIScreen.main.bounds.height/2
        }
        if configure.scale >= 1 {
            configure.scale = 0.25
        }
        
        let orginY = configure.apexPoint.y + 5
        var orginX: CGFloat = 0
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
        self.triangleCenterX = self.configure.apexPoint.x - orginX
        let frame = CGRect(x: orginX, y: orginY, width: configure.width, height: configure.height)
        super.init(frame: frame)
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
    }
    
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let width:CGFloat = rect.size.width
        let height:CGFloat = rect.size.height
        let radius:CGFloat = 5.0
        let margin:CGFloat = 6.0
        let angleBottomWidth:CGFloat = 12.0
        let lineWidth:CGFloat = 1

        let ref = UIGraphicsGetCurrentContext()

        let path = UIBezierPath.init()
        //起始点
        path.move(to: CGPoint(x: radius, y: margin))
        //顶部三角
        path.addLine(to: CGPoint(x: triangleCenterX - angleBottomWidth/2, y: margin))
        path.addLine(to: CGPoint(x: triangleCenterX, y: 0))
        path.addLine(to: CGPoint(x: triangleCenterX + angleBottomWidth/2, y: margin))
        //右上角圆弧
        path.addArc(withCenter: CGPoint(x: width - radius, y: margin + radius), radius: radius, startAngle: -CGFloat(Double.pi / 2), endAngle: 0.0, clockwise: true)
        //右下角圆弧
        path.addLine(to: CGPoint(x: width - lineWidth / 2, y: height - radius))
        path.addArc(withCenter: CGPoint(x: width - radius, y: height - radius), radius: radius, startAngle: 0.0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        //左下角圆弧
        path.addLine(to: CGPoint(x: width - radius, y: height - lineWidth / 2))
        path.addArc(withCenter: CGPoint(x: radius, y: height - radius), radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        //左上角圆弧
        path.addLine(to: CGPoint(x: lineWidth / 2, y: margin + radius))
        path.addArc(withCenter: CGPoint(x: radius, y: margin + radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 1.5), clockwise: true)
        //闭合
        path.addLine(to: CGPoint(x: radius, y: margin))

        //设置线宽
        ref?.setLineWidth(lineWidth)

        //路径添加到上下文
        ref?.closePath()
        ref?.addPath(path.cgPath)

        //设置样式
        self.configure.fillColor.set()
//        UIColor.red.setStroke()//边框
//        UIColor.white.setFill()//填充样式

        //渲染
        ref?.drawPath(using: .fillStroke)
    }
    
    func show() {
        let shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView.backgroundColor = UIColor.clear
        shadowView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tap.delegate = self
        shadowView.addGestureRecognizer(tap)
        shadowView.backgroundColor = self.configure.shadowColor
        shadowView.addSubview(self)
        self.configure.shadowFatherView.addSubview(shadowView)
        self.configure.shadowFatherView.bringSubview(toFront: shadowView)
    }
    
    @objc func dismiss(){
        self.superview?.removeFromSuperview()
    }
}


extension PXPullView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titileArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "PXPullViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "PXPullViewCell")
        }
        cell?.textLabel?.text = self.titileArr?[indexPath.row]
        cell?.textLabel?.textAlignment = .center
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.pullView(self, didSelectRowAt: indexPath.row, title: self.titileArr![indexPath.row])
        self.dismiss()
    }
}

extension PXPullView: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView" {
            return false
        }
        return true
    }
}
