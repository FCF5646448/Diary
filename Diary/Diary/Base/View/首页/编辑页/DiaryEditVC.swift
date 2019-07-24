//
//  DiaryEditVC.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/20.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import RealmSwift

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
    var storyBook:StoryBookItem?
    var storyItem:StoryItemModel?
    
    init(_ type:EditType,_ diaryItem:DiaryItemModel?=nil,_ storyBook:StoryBookItem?, _ storyItem:StoryItemModel?=nil){
        super.init(nibName: "DiaryEditVC", bundle: Bundle.main)
        self.type = type
        self.diaryItem = diaryItem
        self.storyBook = storyBook
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
        titleTF.placeholder = NSLocalizedString("DiaryEditTitlePH", comment: "DiaryEditTitlePH")
        detailTVPlacehold.text = NSLocalizedString("DiaryEditDesPH", comment: "DiaryEditDesPH")
        
        let btn = UIButton(type: .custom)
        btn.setTitle(NSLocalizedString("保存", comment: "保存"), for: .normal)
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
            self.storyNL.text = self.storyBook?.title
            if self.storyItem == nil {
                //说明是写
                self.dayL.text = timeOnlyToDStr(currentTimeSecond())
                self.weekL.text = getTodayWeekDay(currentTimeSecond())
                self.timeL.text = timeOnlyToTStr(currentTimeSecond())
                
            }else{
                //说明是改
                let time:TimeInterval = TimeInterval(self.storyItem!.time)
                self.dayL.text = timeOnlyToDStr(time)
                self.weekL.text = getTodayWeekDay(time)
                self.timeL.text = timeOnlyToTStr(time)
                self.titleTF.text = self.storyItem!.title
                self.detailTV.text = self.storyItem!.detail
                self.detailTVPlacehold.isHidden = true
            }
        }
    }
    
    @objc func saveBtnAction() {
        // 缓存
        if (self.titleTF.text != nil && self.titleTF.text!.count > 0) && (self.detailTV.text != nil && self.detailTV.text!.count > 0) {
            if self.type == .diary {
                //日记
                if self.diaryItem != nil {
                    //修改
                    let realm = try! Realm()
                    // 先根据时间查找到数据库中的对象，然后进行修改
                    if let origin = realm.objects(DiaryItemModel.self).filter("time ==  \(self.diaryItem!.time)").first {
                        try! realm.write {
                            origin.title = self.titleTF.text!
                            origin.detail = self.detailTV!.text
                        }
                        let alertController = UIAlertController(title: NSLocalizedString("修改成功!", comment: "修改成功!"),
                                                                message: nil, preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                            self.presentedViewController?.dismiss(animated: false, completion: nil)
                        }
                    }
                }else{
                    let itemDiary = DiaryItemModel()
                    itemDiary.title = self.titleTF.text!
                    itemDiary.detail = self.detailTV.text!
                    itemDiary.time = Int(currentTimeSecond())
                    itemDiary.save()
                    self.diaryItem = itemDiary
                    let alertController = UIAlertController(title: NSLocalizedString("添加成功!", comment: "添加成功!"),
                                                            message: nil, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                }
            }else{
                //故事本
                
                if self.storyItem != nil {
                    //修改
                    //修改
                    let realm = try! Realm()
                    // 先根据时间查找到数据库中的对象，然后进行修改
                    if let origin = realm.objects(StoryItemModel.self).filter("time ==  \(self.storyItem!.time)").first {
                        try! realm.write {
                            origin.title = self.titleTF.text!
                            origin.detail = self.detailTV!.text
                        }
                        let alertController = UIAlertController(title: NSLocalizedString("修改成功!", comment: "修改成功!"),
                                                                message: nil, preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                            self.presentedViewController?.dismiss(animated: false, completion: nil)
                        }
                    }
                    return
                }else{
                    //新建
                    let itemStory = StoryItemModel()
                    itemStory.title = self.titleTF.text!
                    itemStory.detail = self.detailTV.text!
                    itemStory.time = Int(currentTimeSecond())
                    itemStory.BookName = self.storyBook!.title
                    self.storyItem = itemStory
                    
                    let realm = try! Realm()
                    // 先根据时间查找到数据库中的对象，然后进行修改
                    if let origin = realm.objects(StoryBookItem.self).filter("time ==  \(self.storyBook!.time)").first {
                        try! realm.write {
                            origin.storys.append(itemStory)
                        }
                    }
                    let alertController = UIAlertController(title: NSLocalizedString("添加成功!", comment: "添加成功!"),
                                                            message: nil, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                }
            }
            
        }else{
            let alertController = UIAlertController(title: NSLocalizedString("请确保标题和正文完整", comment: "请确保标题和正文完整"),
                                                    message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
}

extension DiaryEditVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.detailTVPlacehold.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let t = textView.text, t.count > 0{
            self.detailTVPlacehold.isHidden = true
        }else{
            self.detailTVPlacehold.isHidden = false
        }
    }
}
