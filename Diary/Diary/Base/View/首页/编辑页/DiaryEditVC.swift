//
//  DiaryEditVC.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/20.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class DiaryEditVC: FCFBaseViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var weekL: UILabel!
    @IBOutlet weak var dayL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var storyNL: UILabel!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var titleTFTopGap: NSLayoutConstraint!
    @IBOutlet weak var detailTV: UITextView!
    @IBOutlet weak var detailTVPlacehold: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension DiaryEditVC {
    func initUI() {
        let btn = UIButton(type: .custom)
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        let baritem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = baritem
    }
    
    @objc func saveBtnAction() {
        
    }
}

extension DiaryEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
    }
}
