//
//  UIView+Extension.swift
//  watermarkWipe
//
//  Created by fanxing3 on 2018/7/31.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    var width:CGFloat  {
        get{
            return self.frame.size.width
        }
    }
    
    var height:CGFloat {
        get{
            return self.frame.size.height
        }
    }
    
    var x:CGFloat {
        get{
            return self.frame.origin.x
        }
    }
    
    var y:CGFloat {
        get{
            return self.frame.origin.y
        }
    }
    
}
