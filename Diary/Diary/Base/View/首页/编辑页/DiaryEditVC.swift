//
//  DiaryEditVC.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/20.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

enum EditType {
    case diary //日记
    case story //小故事
}

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
    
    var type:EditType!
    var diaryItem:DiaryItemModel?
    var storyItem:StoryItemModel?
    
    init(_ type:EditType,_ diaryItem:DiaryItemModel?=nil, _ storyItem:StoryItemModel?=nil){
        super.init(nibName: "DiaryEditVC", bundle: Bundle.main)
        self.type = type
        self.diaryItem = diaryItem
        self.storyItem = storyItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        
        if self.type == .diary {
            self.storyNL.isHidden = true
            self.titleTFTopGap.constant = 10.0
            if self.diaryItem == nil {
                //说明是写
                self.dayL.text = timeOnlyToDStr(currentTimeSecond())
                self.weekL.text = getTodayWeekDay(currentTimeSecond())
                self.timeL.text = timeOnlyToTStr(currentTimeSecond())
            }else{
                //说明是改
                let time:TimeInterval = TimeInterval(self.diaryItem!.time)
                self.dayL.text = timeOnlyToDStr(time)
                self.weekL.text = getTodayWeekDay(time)
                self.timeL.text = timeOnlyToTStr(time)
                self.titleTF.text = self.diaryItem!.title
                self.detailTV.text = self.diaryItem!.detail
                self.detailTVPlacehold.isHidden = true
            }
            
        }else{
            self.storyNL.isHidden = false
            self.titleTFTopGap.constant = 60.0
            if self.storyItem == nil {
                //说明是写
                
            }else{
                //说明是改
                
            }
        }
    }
    
    @objc func saveBtnAction() {
        // 缓存
        if (self.titleTF.text != nil && self.titleTF.text!.count > 0) && (self.detailTV.text != nil && self.detailTV.text!.count > 0) {
            
            if self.diaryItem != nil {
                //修改
                return
            }
            
            let itemDiary = DiaryItemModel()
            itemDiary.title = self.titleTF.text!
            itemDiary.detail = self.detailTV.text!
            itemDiary.time = Int(currentTimeSecond())
            itemDiary.save()
            self.diaryItem = itemDiary
//            self.navigationController?.popViewController(animated: true)
        }else{
            
        }
    }
}

extension DiaryEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let t = textView.text, t.count > 0{
            self.detailTVPlacehold.isHidden = true
        }else{
            self.detailTVPlacehold.isHidden = false
        }
        
    }
}
