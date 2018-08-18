//
//  FXHomePageVC.swift
//  watermarkWipe
//
//  Created by fanxing3 on 2018/7/31.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos
import AssetsLibrary
public let bottomHeight:CGFloat = 100
class FXHomePageVC: FXBaseVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var myImage: imageMode = imageMode()
    var padding: CGFloat = 10
    var imageInfo:(CGFloat,CGFloat,CGFloat,CGFloat,CGFloat,CGFloat) = (1,1,1,1,1,1);
    lazy var backGroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var addPicBtn: UIButton = {
        let but = UIButton()
        but.setTitleColor(UIColor.black, for: .normal)
        but.setImage(UIImage.init(named: "add-button"), for: .normal)
        return but
    }()
    lazy var imagePickerController:UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        return imagePicker
    }()
    lazy var screenshotBtn:UIButton = {
        let button = UIButton()
        button.setTitle("   截图去水印", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage.init(named: "scissors"), for: .normal)
        return button
    }()
    lazy var advancedBtn:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.setTitle("高级去水印", for: .normal);
        return button
    }()
    //MARK:lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK:praviteFunc
    override func setupUI(){
        self.view.addSubview(backGroundImageView)
        self.view.addSubview(addPicBtn)
        self.view.addSubview(screenshotBtn)
        self.view.addSubview(advancedBtn)
    }
    override func addConstrains(){
        self.addPicBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        self.backGroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
        self.screenshotBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(60)
            make.width.equalTo(SCREEN_WIDTH/2)
        }
        self.advancedBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
            make.width.equalTo(SCREEN_WIDTH/2)
        }
    }
    override func setStyle(){
        self.navigationController?.navigationBar.isHidden = true;
        self.imagePickerController.delegate = self
        self.view.backgroundColor = UIColor.white
        backGroundImageView.contentMode = .scaleAspectFit
        self.screenshotBtn.isHidden = true
        self.advancedBtn.isHidden = true
    }
    override func eventHandling(){
        //添加图片按钮
        addPicBtn.rx.controlEvent(.touchUpInside).subscribe {[weak self] (event) in
            guard let weakSelf = self else{
                return
            }
            weakSelf.imagePickerController.sourceType = .photoLibrary
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                weakSelf.present(weakSelf.imagePickerController, animated: true, completion: nil)
            }else{
                SVProgressHUD.show(UIImage(), status: "读取相册失败");
            }
            }.disposed(by: disposeBag)
        //截图按钮
        screenshotBtn.rx.controlEvent(.touchUpInside).subscribe {[weak self] (event) in
            guard let weakSelf = self else{
                return
            }
            
            let maxWide = SCREEN_WIDTH - weakSelf.padding*2
            let maxHeight = SCREEN_HEIGHT - bottomHeight - 70
            let bool = weakSelf.myImage.image.size.width/weakSelf.myImage.image.size.height < maxWide/maxHeight
            let imageWidth = bool ? weakSelf.myImage.image.size.width*(maxHeight/weakSelf.myImage.image.size.height):maxWide
            let imageHeight = bool ? maxHeight:weakSelf.myImage.image.size.height*(maxWide/weakSelf.myImage.image.size.width)
            weakSelf.imageInfo.0 = imageWidth
            weakSelf.imageInfo.1 = imageHeight
            weakSelf.imageInfo.2 = (SCREEN_HEIGHT - bottomHeight)/2
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf.backGroundImageView.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(weakSelf.view)
                    make.centerY.equalTo((SCREEN_HEIGHT - bottomHeight)/2)
                    make.width.equalTo(imageWidth)
                    make.height.equalTo(imageHeight)
                })
                weakSelf.view.layoutIfNeeded()
            }, completion: { (bool) in
                let vc = FXScreenShotVC()
                vc.imageInfo = weakSelf.imageInfo
                vc.myImage = weakSelf.myImage
                vc.dismissBlock = { () -> Void in
                    weakSelf.backGroundImageView.snp.remakeConstraints({ (make) in
                        make.centerX.equalTo(weakSelf.view)
                        make.centerY.equalTo(weakSelf.imageInfo.5)
                        make.width.equalTo(weakSelf.imageInfo.3)
                        make.height.equalTo(weakSelf.imageInfo.4)
                    })
                }
                weakSelf.present(vc, animated: false, completion: nil)
            })
        }.disposed(by: disposeBag)
        advancedBtn.rx.controlEvent(.touchUpInside).subscribe {[weak self] (event) in
            guard let weakSelf = self else{
                return
            }
            }.disposed(by: disposeBag)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type:String = (info[UIImagePickerControllerMediaType]as!String)
        print("\(info)")
        //当选择的类型是图片
        if type=="public.image"{
            let imgUrl:URL?
            let imageAsset:PHAsset?
            if #available(iOS 11.0, *) {
                imgUrl = info[UIImagePickerControllerReferenceURL] as? URL
                imageAsset = info[UIImagePickerControllerPHAsset] as? PHAsset
            } else {
                imgUrl = info[UIImagePickerControllerReferenceURL] as? URL
                imageAsset = PHAsset.fetchAssets(withALAssetURLs: [imgUrl!], options: nil).firstObject
            }
            let img = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.backGroundImageView.image = img;
            self.myImage.image = img!;
            let maxWide = SCREEN_WIDTH - self.padding*2
            let maxHeight = SCREEN_HEIGHT - 50 - 50
            let bool = self.myImage.image.size.width/self.myImage.image.size.height < maxWide/maxHeight
            let imageWidth = bool ? self.myImage.image.size.width*(maxHeight/self.myImage.image.size.height):maxWide
            let imageHeight = bool ? maxHeight:self.myImage.image.size.height*(maxWide/self.myImage.image.size.width)
            imageInfo.3 = imageWidth
            imageInfo.4 = imageHeight
            imageInfo.5 = (SCREEN_HEIGHT - 50)/2
            self.backGroundImageView.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self.view)
                make.centerY.equalTo((SCREEN_HEIGHT - 50)/2)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
            })
            picker.dismiss(animated: true, completion: nil)
            //重置按钮状态
            self.addPicBtn.isHidden = true
            self.screenshotBtn.isHidden = false
            self.advancedBtn.isHidden = true
            if imgUrl!.absoluteString.lowercased().contains("gif"){
                self.myImage.imageType = .gif
                gifdeal(imageAsset: imageAsset!)
                //gif
            }else{
                self.myImage.imageType = .normal
                //普通图片
            }
        }else{
            SVProgressHUD.show(UIImage(), status: "读取图片失败");
        }
    }
    //获取原生gif资源
    func gifdeal(imageAsset:PHAsset){
        let options = PHImageRequestOptions()
        options.version = .current
        //异步
        options.isSynchronous = true
        PHImageManager.default().requestImageData(for: imageAsset, options: options) { (data, str, origin, info) in
            DispatchQueue.main.async(execute: {
                self.myImage.gifImages = GifHelper.gifWithImages(gifData: data!)
                self.backGroundImageView.animationImages = self.myImage.gifImages
                self.backGroundImageView.animationDuration = 1
                self.backGroundImageView.startAnimating()
            })
        }
    }
}
