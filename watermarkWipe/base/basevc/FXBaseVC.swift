//
//  FXBaseVC.swift
//  watermarkWipe
//
//  Created by fanxing3 on 2018/7/31.
//  Copyright © 2018年 fanxing3. All rights reserved.
//

import UIKit
import RxSwift

class FXBaseVC: UIViewController {
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addConstrains()
        setStyle()
        eventHandling()
    }
    func setupUI(){
    }
    func addConstrains(){
        
    }
    func setStyle(){
        
    }
    func eventHandling(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
