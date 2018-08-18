//
//  FXScreenShotVC.swift
//  watermarkWipe
//
//  Created by fanxing3 on 2018/8/10.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit
import Photos
typealias DismissBlock = ()-> Void
class FXScreenShotVC: FXBaseVC,UICollectionViewDelegate,UICollectionViewDataSource{
    var myImage: imageMode = imageMode()
    var collectionViewDataSource:[[String:String]] = [["string":"取消","imageName":"close"],["string":"截取","imageName":"scissors"]];
    lazy var backGroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var obscurationView:ObscurationView = {
        let obscurationView = ObscurationView()
        return obscurationView
    }()
    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize.init(width: 70, height: bottomHeight)
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        return collection
    }()
    var imageInfo:(CGFloat,CGFloat,CGFloat,CGFloat,CGFloat,CGFloat) = (1,1,1,1,1,1);
    var disposeImage: UIImage?
    var disposeImages: [UIImage] = [UIImage]()
    var dismissBlock:DismissBlock?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI() {
        self.view.addSubview(backGroundImageView)
        self.view.addSubview(obscurationView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FXItemCell.self, forCellWithReuseIdentifier: "FXItemCell")
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        self.view.bringSubview(toFront: collectionView)
    }
    override func setStyle() {
        backGroundImageView.contentMode = .scaleAspectFit
        self.view.backgroundColor = UIColor.white
        obscurationView.imageViewRect = CGRect.init(x: (SCREEN_WIDTH - self.imageInfo.0)/2, y: ((SCREEN_HEIGHT - bottomHeight)/2 - self.imageInfo.1/2), width: self.imageInfo.0, height: self.imageInfo.1)
        obscurationView.imageSize = self.myImage.image.size
        obscurationView.targetSize = CGRect.init(x: (SCREEN_WIDTH - self.imageInfo.0 + 20)/2, y: ((SCREEN_HEIGHT - bottomHeight)/2 - self.imageInfo.1/2) + 10, width: self.imageInfo.0 - 20, height: self.imageInfo.1 - 20)
        obscurationView.initializationTargetViewSize()
        if myImage.imageType == .normal{
            backGroundImageView.image = self.myImage.image
        }else{
            backGroundImageView.animationImages = self.myImage.gifImages
            backGroundImageView.animationDuration = self.myImage.duration
            backGroundImageView.startAnimating()
        }
    }
    override func addConstrains() {
        backGroundImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.imageInfo.2)
            make.width.equalTo(self.imageInfo.0)
            make.height.equalTo(self.imageInfo.1)
        }
        obscurationView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(collectionView.snp.top)
        }
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(bottomHeight)
            make.right.equalTo(0)
        }
    }
    func dismissWithAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.obscurationView.isHidden = true
            self.backGroundImageView.snp.remakeConstraints { (make) in
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.imageInfo.5)
                make.width.equalTo(self.imageInfo.3)
                make.height.equalTo(self.imageInfo.4)
            }
            self.view.layoutIfNeeded()
            if self.dismissBlock != nil{
                self.dismissBlock!()
            }
        }, completion: { (bool) in
            self.dismiss(animated: false, completion: nil)
        })
        
    }
    func saveImageToPhotosAlbum(){
        if myImage.imageType == .normal{
            guard let image = disposeImage else{
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }else{
            SVProgressHUD.show(withStatus: "正在加载")
            GifHelper.createGifWith(disposeImages: disposeImages) { (savePath) in
                GifHelper.saveToPhotoAlbum(doucmentStr:savePath)
                SVProgressHUD.dismiss()
            }
        }
        
    }
    @objc private func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject?){
        if (error != nil){
            SVProgressHUD.show(UIImage(), status: "保存失败")
        }else{
            SVProgressHUD.show(UIImage(), status: "保存成功，您可以到相册中查看哦")
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:collectionViewDelegate、collectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FXItemCell", for: indexPath) as! FXItemCell
        cell.label.text = collectionViewDataSource[indexPath.row]["string"]
        cell.imageView.image = UIImage.init(named: collectionViewDataSource[indexPath.row]["imageName"]!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionViewDataSource[indexPath.row]["string"]! {
        case "取消":
            dismissWithAnimation()
            break
        case "截取":
            guard  obscurationView.outputRect.width > 0 || obscurationView.outputRect.height < 0 else{
                SVProgressHUD.show(UIImage(), status: "请选择适当的区域哦")
                return
            }
            if myImage.imageType == .normal{
                //截取图片
                self.disposeImage = UIImage.imageForImage(image: self.myImage.image, rect: obscurationView.outputRect)
                backGroundImageView.image = self.disposeImage
            }else{
                //截取gif
                for image in myImage.gifImages{
                    disposeImages.append(UIImage.imageForImage(image: image, rect: obscurationView.outputRect))
                }
                backGroundImageView.stopAnimating()
                backGroundImageView.animationImages = disposeImages
                backGroundImageView.animationDuration = myImage.duration
                backGroundImageView.startAnimating()
            }
            collectionViewDataSource.remove(at: 1)
            collectionViewDataSource.append(["string":"保存","imageName":"save"])
            collectionView.reloadData()
            obscurationView.isHidden = true
            break
        case "保存":
            self.saveImageToPhotosAlbum()
            break
        default:
            break
        }
    }

}
