//
//  StoryEditVC.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/20.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import RealmSwift

class StoryEditVC: FCFBaseViewController {
    @IBOutlet weak var titleHintL: UILabel!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var desHIntL: UILabel!
    @IBOutlet weak var desTF: UITextView!
    @IBOutlet weak var screenImg: UIImageView!
    @IBOutlet weak var desPlaceHolder: UILabel!
    
    var imgName:String = "000"
    
    var itemStory:StoryBookItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        //
    }
    
    func initUI() {
        self.desTF.delegate = self
        let btn = UIButton(type: .custom)
        btn.setTitle(NSLocalizedString("保存", comment: "保存"), for: .normal)
        btn.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
        let baritem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = baritem
        
        titleHintL.text = NSLocalizedString("故事名称", comment: "故事名称")
        desHIntL.text = NSLocalizedString("故事描述", comment: "故事描述")
        
        titleTF.placeholder = NSLocalizedString("故事名称PH", comment: "故事名称Placehold")
        desPlaceHolder.text = NSLocalizedString("故事描述PH", comment: "故事描述Placehold")
        
    }
    
    @objc func saveBtnAction() {
        self.view.endEditing(true)
        // 缓存
        if (self.titleTF.text != nil && self.titleTF.text!.count > 0) && (self.desTF.text != nil && self.desTF.text!.count > 0) {
            
            if self.itemStory != nil {
                let realm = try! Realm()
                // 先根据时间查找到数据库中的对象，然后进行修改
                if let origin = realm.objects(StoryBookItem.self).filter("time ==  \(self.itemStory!.time)").first {
                    try! realm.write {
                        origin.title = self.titleTF.text!
                        origin.des = self.desTF!.text
                        origin.imgName = self.imgName
                    }
                }
                
                let alertController = UIAlertController(title: NSLocalizedString("修改成功!", comment: "修改成功!"),
                                                        message: nil, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                }
                return
            }
                
            let itemStory = StoryBookItem()
            itemStory.title = self.titleTF.text!
            itemStory.time = Int(currentTimeSecond())
            itemStory.des = self.desTF!.text
            itemStory.imgName = self.imgName
            itemStory.save()
            
            self.itemStory = itemStory
            
            let alertController = UIAlertController(title: NSLocalizedString("添加成功!", comment: "添加成功!"),
                                                    message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }else{
            let alertController = UIAlertController(title: NSLocalizedString("请确保标题和描述完整", comment: "请确保标题和描述完整"),
                                                    message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    
    @IBAction func imgTapAction(_ sender: Any) {
        let x = arc4random() % 26;
        let imgName = String(format: "%03d", x)
        self.imgName = imgName
        screenImg.image = UIImage(named: imgName)
    }
}

extension StoryEditVC:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.desPlaceHolder.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let t = textView.text, t.count > 0{
            self.desPlaceHolder.isHidden = true
        }else{
            self.desPlaceHolder.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let des = textView.text, des.count > 60 {
            let subStr = String(des[..<des.index(before: des.index(des.startIndex, offsetBy: 60))])
            self.desTF.text = subStr
            let alertController = UIAlertController(title: NSLocalizedString("请确保60字以内", comment: "请确保60字以内"),
                                                    message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.5) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
}

