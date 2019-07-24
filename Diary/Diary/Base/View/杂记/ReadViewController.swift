//
//  ReadViewController.swift
//  Tally
//
//  Created by 冯才凡 on 2019/6/24.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import RealmSwift

class ReadViewController: FCFBaseViewController {
    var collectView:UICollectionView!
    
    lazy var hint:UIView = {
        let imgW:CGFloat = 280
        let hintH:CGFloat = 80
        let v = UIView(frame: CGRect(x: (WIDTH - imgW)/2.0, y: (HEIGHT - kTabBarHeight - kNavBarHeight - imgW - 80 - 10)/2.0, width: imgW, height: (imgW + 80 + 10)))
        
        let imgv = UIImageView(frame: CGRect(x: 0 , y: 0 , width: imgW, height: imgW))
        imgv.image = UIImage(named: "02")
        imgv.contentMode = UIView.ContentMode.scaleAspectFill
        imgv.layer.cornerRadius = imgW/2.0
        imgv.layer.masksToBounds = true
        v.addSubview(imgv)
        
        let hint = UILabel(frame: CGRect(x: 0, y: imgv.bottom + 10, width: imgW, height: hintH))
        hint.numberOfLines = 0
        hint.text = NSLocalizedString("storyHint", comment: "storyHint")
        hint.font = UIFont(name: "DINAlternate-Bold", size: 16)
        hint.textAlignment = .left
        hint.textColor = UIColor.hex(0x8e8e93)
        v.addSubview(hint)
        
        return v
    }()
    
    var dataSource:[StoryBookItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("storys", comment: "storys")
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTallyHistory()
    }
}

extension ReadViewController {
    func initUI() {
        let btn = UIButton(type: .custom)
        btn.setTitle(NSLocalizedString("添加", comment: "添加"), for: .normal)
        btn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        let rightBaritem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = rightBaritem
        
        view.addSubview(self.hint)
        
        let layout = XCollectionViewLayout()
        layout.transformStyle = .linerTransform
        layout.itemSize = CGSize(width: WIDTH - 50*2.0, height: (HEIGHT - kTabBarHeight - kNavBarHeight - 50*2.0))
        collectView = UICollectionView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT - kNavBarHeight - kTabBarHeight), collectionViewLayout: layout)
        collectView.backgroundColor = UIColor.white
        collectView.delegate = self
        collectView.dataSource = self
        collectView.registerNibWithCell(ReadItemCell.self)
        view.addSubview(collectView)
        
        view.bringSubviewToFront(self.hint)
    }
    
    //    从数据库获取数据
    func searchTallyHistory() {
        self.dataSource.removeAll()
        // 获取所有的记录
        let realm = try! Realm()
        let allRecord:Results<StoryBookItem> = realm.objects(StoryBookItem.self)
        if allRecord.count > 0 {
            for item in allRecord {
                self.dataSource.append(item)
            }
        }
        // 按时间排序
        self.dataSource.sort { (elem0, emem1) -> Bool in
            return elem0.time > emem1.time
        }
        
        if self.dataSource.count > 0 {
            self.hint.isHidden = true
        }else{
            self.hint.isHidden = false
        }
        
        collectView.reloadData()
    }
}

extension ReadViewController {
    @objc func addBtnAction() {
        let vc = StoryEditVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReadViewController : UICollectionViewDelegate, UICollectionViewDataSource  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ReadItemCell = collectionView.dequeueReusableCell(ReadItemCell.self, indexPath: indexPath)
        cell.addAllShadow(shadowRadius: 10, shadowColor: UIColor.black.cgColor, offset: CGSize(width: 0, height: 2), opacity: 0.6)
        if indexPath.row < self.dataSource.count {
            let m = self.dataSource[indexPath.row]
            cell.bgImag.image = UIImage(named: m.imgName)
            cell.nameL.text = m.title
            cell.detailL.text =  "—— \(NSLocalizedString("共", comment: "共"))\(m.storys.count)\(NSLocalizedString("集", comment: "集")) ——"
            cell.desL.text =  m.des
            cell.timeL.text = timeToDStr(TimeInterval(m.time))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectView.collectionViewLayout.clickCell(at: indexPath) {
            print("click cell at section: \(indexPath.section)  at item: \(indexPath.item)")
            if indexPath.row < self.dataSource.count {
                let m = self.dataSource[indexPath.row]
                let vc = StoryListVC(m)
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

