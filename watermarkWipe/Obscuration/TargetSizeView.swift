//
//  TargetSizeView.swift
//  watermarkWipe
//
//  Created by fanxing3 on 2018/8/7.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit
import SnapKit
enum TouchesPoint {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case topMiddle
    case bottomMiddle
    case leftMiddle
    case rightMiddle
    case center
}
typealias TargetFrameCallBack = (CGRect) -> Void
class TargetSizeView: UIView {
    var minLength:CGFloat = 60
    var touchesPoint:TouchesPoint?
    var targetPadding:CGFloat = 20.0
    var startPoint:CGPoint = CGPoint.zero
    var startFrame:CGRect = CGRect.zero
    var targetFrameCallBack:TargetFrameCallBack?
    var selectedColor: UIColor = UIColor.red
    //四角的layer
    lazy var topLeftLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect.init(x: -3, y: -3, width: 30, height: 30)
        return layer
    }()
    lazy var topRightLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect.init(x: -3, y: -3, width: 30, height: 30)
        return layer
    }()
    lazy var bottomLeftLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect.init(x: -3, y: -3, width: 30, height: 30)
        return layer
    }()
    lazy var bottomRightLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect.init(x: -3, y: -3, width: 30, height: 30)
        return layer
    }()
    lazy var topMiddleLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect.init(x: -3, y: -3, width: 30, height: 30)
        return layer
    }()
    lazy var bottomMiddleLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect.init(x: -3, y: -3, width: 30, height: 30)
        return layer
    }()
    lazy var leftMiddleLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect.init(x: -3, y: -3, width: 30, height: 30)
        return layer
    }()
    lazy var rightMiddleLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect.init(x: -3, y: -3, width: 30, height: 30)
        return layer
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.layer.addSublayer(topLeftLayer)
        self.layer.addSublayer(topRightLayer)
        self.layer.addSublayer(bottomLeftLayer)
        self.layer.addSublayer(bottomRightLayer)
        self.layer.addSublayer(topMiddleLayer)
        self.layer.addSublayer(bottomMiddleLayer)
        self.layer.addSublayer(leftMiddleLayer)
        self.layer.addSublayer(rightMiddleLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    //MARK:pravite方法
    //判断初始触摸方向
    func judgeTouchesPoint(point:CGPoint){
        let horizontalPadding:CGFloat = frame.width < minLength + 30 ? frame.width/3:30;
        let verticalPadding:CGFloat = frame.height < minLength + 30 ? frame.height/3:30;
        resetLayerColor()
        if (point.x > 0 && point.x < horizontalPadding && point.y > 0 && point.y < verticalPadding){
            touchesPoint = .topLeft
            topLeftLayer.backgroundColor = selectedColor.cgColor
        }else if (point.x > self.width-horizontalPadding && point.x < self.width && point.y > 0 && point.y < verticalPadding){
            touchesPoint = .topRight
            topRightLayer.backgroundColor = selectedColor.cgColor
        }else if (point.x > 0 && point.x < horizontalPadding && point.y < self.height && point.y > self.height - verticalPadding){
            touchesPoint = .bottomLeft
            bottomLeftLayer.backgroundColor = selectedColor.cgColor
        }else if (point.x > self.width-horizontalPadding && point.x < self.width && point.y < self.height && point.y > self.height - verticalPadding){
            touchesPoint = .bottomRight
            bottomRightLayer.backgroundColor = selectedColor.cgColor
        }else if (point.x > horizontalPadding && point.x < self.width - horizontalPadding && point.y > verticalPadding && point.y < self.height - verticalPadding){
            touchesPoint = .center
        }else if (point.x > horizontalPadding && point.x < self.width - horizontalPadding && point.y > 0 && point.y < verticalPadding){
            touchesPoint = .topMiddle
            topMiddleLayer.backgroundColor = selectedColor.cgColor
        }else if (point.x > horizontalPadding && point.x < self.width - horizontalPadding && point.y > self.height - verticalPadding && point.y < self.height){
            touchesPoint = .bottomMiddle
            bottomMiddleLayer.backgroundColor = selectedColor.cgColor
        }else if (point.x > 0 && point.x < horizontalPadding && point.y > verticalPadding && point.y < self.height - verticalPadding){
            touchesPoint = .leftMiddle
            leftMiddleLayer.backgroundColor = selectedColor.cgColor
        }else if (self.width - horizontalPadding > 0 && point.x < self.width && point.y > verticalPadding && point.y < self.height - verticalPadding){
            touchesPoint = .rightMiddle
            rightMiddleLayer.backgroundColor = selectedColor.cgColor
        }
    }
    //重置layer颜色
    func resetLayerColor(){
        topLeftLayer.backgroundColor = UIColor.white.cgColor
        topRightLayer.backgroundColor = UIColor.white.cgColor
        bottomLeftLayer.backgroundColor = UIColor.white.cgColor
        bottomRightLayer.backgroundColor = UIColor.white.cgColor
        topMiddleLayer.backgroundColor = UIColor.white.cgColor
        bottomMiddleLayer.backgroundColor = UIColor.white.cgColor
        leftMiddleLayer.backgroundColor = UIColor.white.cgColor
        rightMiddleLayer.backgroundColor = UIColor.white.cgColor
    }
    //计算扩大的体积
    func calculateResizeFrame(point:CGPoint){
        guard let touchesType = touchesPoint else{
            return
        }
        let x = point.x - startPoint.x
        let y = point.y - startPoint.y
        var isMinx = false
        var isMiny = false
        switch touchesType {
        case .topLeft:
            isMinx = (frame.size.width - x) < minLength ? true:false
            isMiny = (frame.size.height - y) < minLength ? true:false
            self.frame = CGRect.init(x: isMinx ? frame.origin.x:frame.origin.x + x, y: isMiny ? frame.origin.y:frame.origin.y + y, width: isMinx ? frame.width:frame.size.width - x, height: isMiny ? frame.size.height:frame.size.height - y)
            break
        case .topRight:
            isMinx = (startFrame.size.width + x) < minLength ? true:false
            isMiny = (frame.size.height - y) < minLength ? true:false
            self.frame = CGRect.init(x: frame.origin.x, y: isMiny ? frame.origin.y:frame.origin.y + y, width: isMinx ? frame.width:startFrame.size.width + x, height: isMiny ? frame.height:frame.size.height - y)
            break
        case .bottomLeft:
            isMinx = (frame.size.width - x) < minLength ? true:false
            isMiny = (startFrame.size.height + y) < minLength ? true:false
            self.frame = CGRect.init(x: isMinx ? frame.origin.x:frame.origin.x + x, y: frame.origin.y, width: isMinx ? frame.width:frame.size.width - x, height: isMiny ? frame.height:startFrame.size.height + y)
            break
        case .bottomRight:
            isMinx = (startFrame.size.width + x) < minLength ? true:false
            isMiny = (startFrame.size.height + y) < minLength ? true:false
            self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: isMinx ? frame.width:startFrame.size.width + x, height: isMiny ? frame.size.height:startFrame.size.height + y)
            break
        case .center:
            self.frame = CGRect.init(x: frame.origin.x + x, y: frame.origin.y + y, width: frame.size.width, height: frame.size.height)
            break
        case .topMiddle:
            isMiny = (frame.height - y) < minLength ? true:false
            self.frame = CGRect.init(x: frame.origin.x, y: isMiny ? frame.origin.y:frame.origin.y + y, width: frame.size.width, height: isMiny ? frame.height:frame.height - y)
            break
        case .bottomMiddle:
            isMiny = (startFrame.size.height + y) < minLength ? true:false
            self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: isMiny ? frame.height:startFrame.size.height + y)
            break
        case .leftMiddle:
            isMinx = (frame.width - x) < minLength ? true:false
            self.frame = CGRect.init(x: isMinx ? frame.origin.x:frame.origin.x + x, y: frame.origin.y, width: isMinx ? frame.width:frame.width - x, height: self.height)
            break
        case .rightMiddle:
            isMinx = (startFrame.width + x) < minLength ? true:false
            self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: isMinx ? frame.width:startFrame.width + x, height: self.height)
            break
        }
        if targetFrameCallBack != nil{
            targetFrameCallBack!(self.frame)
            setLayers()
        }
    }
    func setLayers(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        topLeftLayer.frame = CGRect.init(x: -2, y: -2, width: 30, height: 30)
        topRightLayer.frame = CGRect.init(x: frame.width - 28, y: -2, width: 30, height: 30)
        bottomLeftLayer.frame = CGRect.init(x: -2, y: frame.height-28, width: 30, height: 30)
        bottomRightLayer.frame = CGRect.init(x: frame.width - 28, y: frame.height-28, width: 30, height: 30)
        topMiddleLayer.frame = CGRect.init(x: frame.width/2 - 5, y: -2, width: 10, height: 2)
        bottomMiddleLayer.frame = CGRect.init(x: frame.width/2 - 5, y: self.height, width: 10, height: 2)
        leftMiddleLayer.frame = CGRect.init(x: -2, y: frame.height/2 - 5, width: 2, height: 10)
        rightMiddleLayer.frame = CGRect.init(x:frame.width, y: frame.height/2 - 5, width: 2, height: 10)
        CATransaction.commit()
    }
    //触摸方法回调
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first{
            let localPoint = touch.location(in: self)
            judgeTouchesPoint(point: localPoint)
            startPoint = localPoint
            startFrame = self.frame
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first{
            let localPoint = touch.location(in: self)
            calculateResizeFrame(point: localPoint)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        resetLayerColor()
    }

}
