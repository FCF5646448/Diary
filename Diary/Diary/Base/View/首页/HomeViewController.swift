//
//  HomeViewController.swift
//  CartoonShow
//
//  Created by 冯才凡 on 2019/6/14.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class HomeViewController: FCFBaseViewController {
    
    
    var collectionView:UICollectionView!
    var hasAnimate:Bool = false
    
    var originData:[DiaryItemModel] = []
    
    var dataSource:[MonthDiaryModel] = []
    
    lazy var addBtn:UIButton = {
        let b = UIButton(type: .custom)
        b.frame = CGRect(x: WIDTH - 64 - 15, y: HEIGHT - kTabBarHeight - kNavBarHeight - 64 - 15 , width: 64, height: 64)
        b.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        b.setImage(UIImage(named: "add"), for: .normal)
        b.backgroundColor = UIColor.hex(MainColor)
        b.layer.cornerRadius = 32
        
        b.layer.shadowColor = UIColor.hex(MainColor).cgColor
        b.layer.shadowOffset = CGSize(width: 0, height: 2)
        b.layer.shadowOpacity = 0.5
        b.layer.shadowRadius = 32
        
        return b
    }()
    
    lazy var hint:UIView = {
        let imgW:CGFloat = 280
        let hintH:CGFloat = 80
        let v = UIView(frame: CGRect(x: (WIDTH - imgW)/2.0, y: (HEIGHT - kTabBarHeight - kNavBarHeight - imgW - 80 - 10)/2.0 + 40, width: imgW, height: (imgW + 80 + 10)))
        
        let imgv = UIImageView(frame: CGRect(x: 0 , y: 0 , width: imgW, height: imgW))
        imgv.image = UIImage(named: "01")
        imgv.contentMode = UIView.ContentMode.scaleAspectFill
        imgv.layer.cornerRadius = imgW/2.0
        imgv.layer.masksToBounds = true
        v.addSubview(imgv)
        
        let hint = UILabel(frame: CGRect(x: 0, y: imgv.bottom + 10, width: imgW, height: hintH))
        hint.numberOfLines = 0
        hint.text = "每一次经历都将成为你美好的回忆.\n这里可以记录人生的点滴.\n开启记录吧.."
        hint.font = UIFont(name: "DINAlternate-Bold", size: 16)
        hint.textAlignment = .left
        hint.textColor = UIColor.hex(0x8e8e93)
        v.addSubview(hint)
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "笔记"
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTallyHistory()
    }
    
}

extension HomeViewController {
    func initUI() {
        let waveView = WaveView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 80))
        view.addSubview(waveView)
        waveView.startWave()
        //添加按钮
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 25
        flow.itemSize = CGSize(width: 125, height: 145)
        flow.headerReferenceSize = CGSize(width: WIDTH, height: 30)
        flow.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        
        let colloect = UICollectionView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT - kNavBarHeight - kTabBarHeight ), collectionViewLayout: flow)
        colloect.backgroundColor = UIColor.white.withAlphaComponent(0)
        colloect.contentInset = UIEdgeInsets(top: 5, left: 40, bottom: 5, right: 40)
        colloect.delegate = self
        colloect.dataSource = self
        colloect.registerNibWithCell(HomeItemCell.self)
        colloect.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeItemHeader")
        
        self.collectionView = colloect
        if #available(iOS 11, *) {
            colloect.contentInsetAdjustmentBehavior = .never
        }else{
            automaticallyAdjustsScrollViewInsets = false
        }
        
        view.addSubview(colloect)
        view.addSubview(self.addBtn)
        view.addSubview(self.hint)
        
    }

    
//    从数据库获取数据
    func searchTallyHistory() {
        self.dataSource.removeAll()
        self.originData.removeAll()
        // 获取所有的记录
        let realm = try! Realm()
        let allRecord:Results<DiaryItemModel> = realm.objects(DiaryItemModel.self)
        if allRecord.count > 0 {
            for item in allRecord {
                self.originData.append(item)
            }
        }
        // 按时间排序
        self.originData.sort { (elem0, emem1) -> Bool in
            return elem0.time > emem1.time
        }

        // 有哪些月份、日期
        var monthList:[String] = []
        for item in self.originData {
            let m = timeToMStr(TimeInterval(item.time))
            if !monthList.contains(m) {
                monthList.append(m)
            }
        }

        for m in monthList {
            let mItem = MonthDiaryModel()
            mItem.monthStr = m
            var tempM = [DiaryItemModel]()
            for dItem in self.originData {
                let dstr = timeToDStr(TimeInterval(dItem.time))
                if dstr.contains(m) {
                    tempM.append(dItem)
                }
            }
            mItem.list = tempM
            self.dataSource.append(mItem)
        }

        if self.dataSource.count > 0 {
            self.hint.isHidden = true
        }else{
            self.hint.isHidden = false
        }

        collectionView.reloadData()
    }
    
}

extension HomeViewController {
    @objc func addBtnAction() {
        
        let vc = DiaryEditVC(.diary,nil,nil,nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
//        let vc = DiaryEditVC()
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc, animated: true)
    }
}


extension HomeViewController {
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let m = self.dataSource[section]
        return m.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HomeItemCell = collectionView.dequeueReusableCell(HomeItemCell.self, indexPath: indexPath)
        if indexPath.section < self.dataSource.count {
            let m = self.dataSource[indexPath.section]
            if indexPath.item < m.list.count {
                let d = m.list[indexPath.item]
                cell.detailL.text = d.detail
                cell.titleL.text = d.title
                cell.timeL.text = timeToDStr(TimeInterval(d.time))
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HomeItemHeader", for: indexPath)
            var tempL:UILabel!
            if let lb:UILabel = header.viewWithTag(10) as? UILabel {
                tempL = lb
            }else{
                let lb = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 30))
                lb.text = "年月"
                lb.font = UIFont.systemFont(ofSize: 12)
                lb.textColor = UIColor.hex("8a8a8a")
                lb.tag = 10
                header.addSubview(lb)
                tempL = lb
            }
            let m = self.dataSource[indexPath.section]
            tempL.text = m.monthStr
            return header
        }
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section < self.dataSource.count {
            let m = self.dataSource[indexPath.section]
            if indexPath.item < m.list.count {
                let d = m.list[indexPath.item]
                
                let vc = DiaryEditVC(.diary, d,nil,nil)
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

