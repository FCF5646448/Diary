//
//  StoryEditVC.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/20.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class StoryEditVC: FCFBaseViewController {
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var desTF: UITextView!
    @IBOutlet weak var screenImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        //
    }
    
    func initUI() {
        let btn = UIButton(type: .custom)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        let baritem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = baritem
    }
    
    @objc func saveBtnAction() {
        self.view.endEditing(true)
        
    }
    
    
    @IBAction func imgTapAction(_ sender: Any) {
        let x = arc4random() % 26;
        let imgName = String(format: "%03d", x)
        print(imgName)
        screenImg.image = UIImage(named: imgName)
    }
}

