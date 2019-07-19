//
//  CSTabBarController.swift
//  CartoonShow
//
//  Created by 冯才凡 on 2019/6/14.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class FCFTabBarController: UITabBarController {
    lazy var homeNavi:FCFNavigationController = {
        let n = FCFNavigationController(rootViewController: HomeViewController())
        n.setTabBar("write", "write_sel", UIColor.hex("8a8a8a"), UIColor.hex(MainColor))
        return n
    }()
    
    lazy var readNavi:FCFNavigationController = {
        let n = FCFNavigationController(rootViewController: ReadViewController())
        n.setTabBar("read", "read_sel", UIColor.hex("8a8a8a"), UIColor.hex(MainColor))
        return n
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFrame()
    }
    
    func initFrame() {
        self.addChild(self.homeNavi)
        self.addChild(self.readNavi)
    }
}
