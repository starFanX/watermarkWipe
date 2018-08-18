//
//  UIImage+Extension.swift
//  watermarkWipe
//
//  Created by 星 Fan on 2018/8/16.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{
    class func imageForImage(image: UIImage ,rect:CGRect) -> UIImage{
        let imgRef = image.cgImage?.cropping(to: rect)
        let newImage = UIImage.init(cgImage: imgRef!)
        return newImage
    }
}
