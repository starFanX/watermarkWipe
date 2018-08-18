//
//  FXItemCell.swift
//  watermarkWipe
//
//  Created by 星 Fan on 2018/8/14.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit

class FXItemCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var label:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addMyConstraints()
    }
    func setupUI(){
        self.addSubview(label)
        self.addSubview(imageView)
    }
    func addMyConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
