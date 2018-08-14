//
//  FXItemCell.swift
//  watermarkWipe
//
//  Created by 星 Fan on 2018/8/14.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit

class FXItemCell: UICollectionViewCell {
    lazy var label:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
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
    }
    func addMyConstraints() {
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
