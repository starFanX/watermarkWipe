//
//  FXImageManager.swift
//  watermarkWipe
//
//  Created by fanxing3 on 2018/8/2.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit

class FXImageManager: NSObject {
//    var image: 
    static let instance: FXImageManager = FXImageManager()
    class func shared() -> FXImageManager {
        return instance
    }
}
