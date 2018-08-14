//
//  ObscurationView.swift
//  watermarkWipe
//
//  Created by fanxing3 on 2018/8/7.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit
import RxSwift

class ObscurationView: UIView {
    var disposeBag = DisposeBag()
    lazy var targetSizeView:TargetSizeView = {
        let view = TargetSizeView.init(frame: self.targetSize)
        return view
    }()
    lazy var path:UIBezierPath = {
        let path = UIBezierPath.init(rect:SCREEN_BOUNDS)
        path.append(UIBezierPath.init(rect: self.targetSize).reversing())
        return path
    }()
    lazy var shapLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = self.path.cgPath
        layer.strokeColor = UIColor.red.cgColor
        return layer
    }()
    @objc dynamic var targetSize:CGRect = CGRect.init(x: 10, y: (SCREEN_HEIGHT-300)/2, width: SCREEN_WIDTH-20, height: 300)
    //图片区域，用于机选相对区域
    var imageViewRect:CGRect = CGRect.zero
    //图片的真实尺寸
    var imageSize: CGSize = CGSize.zero
    //输出区域，可用于截图的尺寸
    var outputRect:CGRect = CGRect.zero
    convenience init(targetSize:CGRect){
        self.init(frame:CGRect.zero)
        self.targetSize = targetSize
        targetSizeView.frame = self.targetSize
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addConstrains()
        setStyle()
        eventHandling()
    }
    func setupUI(){
        self.layer.mask = shapLayer
        self.addSubview(targetSizeView)
        self.bringSubview(toFront: targetSizeView)
    }
    func addConstrains(){
        
    }
    func setStyle(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    func initializationTargetViewSize(){
        self.targetSizeView.frame = self.targetSize
        self.targetSizeView.setLayers()
    }
    func eventHandling(){
        self.rx.observe(CGRect.self, "targetSize").asObservable().subscribe {[weak self] (event) in
            guard let weakSelf = self else{
                return
            }
            weakSelf.path.removeAllPoints()
            weakSelf.path.append(UIBezierPath.init(rect:SCREEN_BOUNDS))
            weakSelf.path.append(UIBezierPath.init(rect: weakSelf.targetSize).reversing())
            weakSelf.shapLayer.path = weakSelf.path.cgPath
        }.disposed(by: disposeBag)
        targetSizeView.targetFrameCallBack = {[weak self] (frame) -> Void in
            guard let weakSelf = self else {
                return
            }
            weakSelf.targetSize = frame
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
