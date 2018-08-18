//
//  imageMode.swift
//  watermarkWipe
//
//  Created by 星 Fan on 2018/8/17.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit
enum ImageType {
    case normal
    case gif
}

struct imageMode {
    //图片类型
    var imageType:ImageType = .normal
    //图片
    var image: UIImage = UIImage()
    //gif中的图片组
    var gifImages: [UIImage] = [UIImage]()
    //动画时间
    var duration:TimeInterval = 1
}
