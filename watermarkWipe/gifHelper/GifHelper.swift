//
//  GifHelper.swift
//  watermarkWipe
//
//  Created by 星 Fan on 2018/8/17.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
class GifHelper: NSObject {
    //分解gif图
    class func gifWithImages(gifData:Data) ->[UIImage]{
        var imageArr = [UIImage]()
        if let imgDataSource:CGImageSource = CGImageSourceCreateWithData(gifData as CFData, nil){
            let gifImageCount:Int = CGImageSourceGetCount(imgDataSource)
            for i in 0...gifImageCount-1{
                if let imageref:CGImage = CGImageSourceCreateImageAtIndex(imgDataSource, i, nil){
                    let image:UIImage = UIImage.init(cgImage: imageref, scale: UIScreen.main.scale, orientation: .up)
                    imageArr.append(image)
                }
            }
        }
        return imageArr
    }
    //合成gif保存到本地
    class func createGifWith(disposeImages:[UIImage],compelete:@escaping (String)->Void){
        DispatchQueue.global().async {
            //异步
            let cgimagePropertiesDic = [kCGImagePropertyGIFDelayTime as String:0.1]
            let cgimagePropertiesDestDic = [kCGImagePropertyGIFDictionary as String:cgimagePropertiesDic]
            let doucmentStr = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).last! + "/text.gif"
            let url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, doucmentStr as CFString, CFURLPathStyle.cfurlposixPathStyle, true)
            let destination = CGImageDestinationCreateWithURL(url!, kUTTypeGIF, disposeImages.count, nil)
            for image in disposeImages{
                CGImageDestinationAddImage(destination!, image.cgImage!, cgimagePropertiesDestDic as CFDictionary)
            }
            let giftPropertiesDic:NSMutableDictionary = NSMutableDictionary()
            giftPropertiesDic.setValue(kCGImagePropertyColorModelRGB as String, forKey: kCGImagePropertyColorModel as String)
            giftPropertiesDic.setValue(16, forKey: kCGImagePropertyDepth as String)
            giftPropertiesDic.setValue(1, forKey: kCGImagePropertyGIFLoopCount as String)
            let giftDictionaryDestDic = [kCGImagePropertyGIFDictionary as String:giftPropertiesDic]
            CGImageDestinationSetProperties(destination!, giftDictionaryDestDic as CFDictionary)
            CGImageDestinationFinalize(destination!)
            DispatchQueue.main.async(execute: {
                compelete(doucmentStr);
            })
        }
    }
    class func saveToPhotoAlbum(doucmentStr:String){
        let imageData = FileManager.default.contents(atPath: doucmentStr)
        PHPhotoLibrary.shared().performChanges({
            PHAssetCreationRequest.forAsset().addResource(with: PHAssetResourceType.photo, data: imageData!, options: nil)
        }) { (success, error) in
            DispatchQueue.main.async(execute: {
                if success{
                    SVProgressHUD.show(UIImage(), status: "保存成功，您可以到相册中查看哦")
                }else{
                    SVProgressHUD.show(UIImage(), status: "保存失败")
                }
            })
        }
    }
    
}
