//
//  HomeViewController.swift
//  CartoonShow
//
//  Created by 冯才凡 on 2019/6/14.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: FCFBaseViewController {
    lazy var addBtn:UIButton = {
        let b = UIButton(type: .custom)
        b.frame = CGRect(x: WIDTH - 64 - 15, y: HEIGHT - kTabBarHeight - kNavBarHeight - 64 - 15, width: 64, height: 64)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "私密"
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}

extension HomeViewController {
    func initUI() {
        
    }
    
}

extension HomeViewController {
    @objc func addBtnAction() {
        
    }
}


