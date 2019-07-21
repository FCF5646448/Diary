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
    
    var tvplacehold:String = "想念一个人，不一定要听到他的声音。想像中的一切，往往比现实稍微美好一点。想念中的那个人，也比现实稍微温暖一点。思念好像是很遥远的一回事，有时却偏偏比现实亲近一点。(不超过70字)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        //
    }
    
    func initUI() {
        self.desTF.delegate = self
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

extension StoryEditVC:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
}

