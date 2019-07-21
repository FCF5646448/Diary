//
//  ReadViewController.swift
//  Tally
//
//  Created by 冯才凡 on 2019/6/24.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

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
        hint.text = "这里会满载回忆和惊喜，将生活化为一个个点滴故事，\n收纳成册，慢慢回味.\n我有故事，你,有酒吗？"
        hint.font = UIFont(name: "DINAlternate-Bold", size: 16)
        hint.textAlignment = .left
        hint.textColor = UIColor.hex(0x8e8e93)
        v.addSubview(hint)
        
        return v
    }()
    
    var dataSource:[StoryBookItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "故事集"
        initUI()
    }
}

extension ReadViewController {
    func initUI() {
        let btn = UIButton(type: .custom)
        btn.setTitle("添加", for: .normal)
        btn.addTarget(self, action: #selector(addBtnAction), for: .touchUpInside)
        let rightBaritem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = rightBaritem
        
        view.addSubview(self.hint)
        
        let layout = XCollectionViewLayout()
        layout.transformStyle = .linerTransform
        layout.itemSize = CGSize(width: WIDTH - 50*2.0, height: (HEIGHT - kTabBarHeight - kNavBarHeight - 50*2.0))
        collectView = UICollectionView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT - kNavBarHeight - kTabBarHeight), collectionViewLayout: layout)
//        collectView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        collectView.backgroundColor = UIColor.white
        collectView.delegate = self
        collectView.dataSource = self
        collectView.registerNibWithCell(ReadItemCell.self)
        view.addSubview(collectView)
        
        view.bringSubviewToFront(self.hint)
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
        return 1//dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ReadItemCell = collectionView.dequeueReusableCell(ReadItemCell.self, indexPath: indexPath)
        cell.addAllShadow(shadowRadius: 10, shadowColor: UIColor.black.cgColor, offset: CGSize(width: 0, height: 2), opacity: 0.6)
        if indexPath.section < self.dataSource.count {
            let m = self.dataSource[indexPath.section]
            cell.bgImag.image = UIImage(named: m.imgName)
            cell.nameL.text = m.title
            cell.detailL.text = "—— 共\(m.storys.count)集 ——"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectView.collectionViewLayout.clickCell(at: indexPath) {
            print("click cell at section: \(indexPath.section)  at item: \(indexPath.item)")
            
            let vc = StoryListVC()
            vc.hidesBottomBarWhenPushed = true
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

