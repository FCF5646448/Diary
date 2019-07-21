//
//  StoryListVC.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class StoryListVC: FCFBaseViewController {
    
    lazy var hintLabel:UILabel = {
        let lb = UILabel(frame: CGRect(x: 0, y: (HEIGHT-60)/2.0 , width: WIDTH, height: 60))
        lb.text = "当前没有任何小故事哦\n，赶紧添加吧..."
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.hex(0x8a8a8a)
        return lb
    }()
    
    lazy var addBtn:UIButton = {
        let b = UIButton(type: .custom)
        b.frame = CGRect(x: WIDTH - 64 - 15, y: HEIGHT - 64 - 15 , width: 64, height: 64)
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
    
    var topView:UIView!
    var leftBtn:UIButton!
    var rightBtn:UIButton!
    
    var imageView: UIImageView! // 图片视图
    let imageViewHeight: CGFloat = kNavBarHeight + 200 // 图片默认高度
    
    var tableView: UITableView! //表格视图
    let rowNumber = 50 // 表格数据条目数
    let rowHeight: CGFloat = 110// 表格行高
    
    var titleStr = "详情"
    var story:StoryBookItem! {
        didSet{
            self.titleStr = self.story.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        initUI()
        
        // 首先创建一个滚动视图，图片还是tableView都放在这个滚动视图中
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        scrollView.contentSize = CGSize(width: WIDTH,
                                        height: CGFloat(rowNumber) * rowHeight + imageViewHeight)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
             automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        // 初始化图片视图
        self.imageView = UIImageView()
        self.imageView.backgroundColor = UIColor.randomColor().withAlphaComponent(0.6)
        self.imageView.frame = CGRect(x: 0, y: 0, width: WIDTH,
                                      height: imageViewHeight)
        self.imageView.image = UIImage(named: "000")
        self.imageView.contentMode = .scaleAspectFill
        scrollView.addSubview(self.imageView)
        
        //创建表视图
        self.tableView = UITableView(frame: CGRect(x: 0, y: imageViewHeight,
                                                   width: WIDTH, height: CGFloat(rowNumber) * rowHeight), style:.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = CGFloat(rowHeight)
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none
        self.tableView!.registerNibWithCell(StoryListCell.self)
        
        scrollView.addSubview(self.tableView!)
        view.addSubview(self.addBtn)
        view.bringSubviewToFront(self.topView)
        view.bringSubviewToFront(self.leftBtn)
        view.bringSubviewToFront(self.rightBtn)
        view.bringSubviewToFront(self.addBtn)
        
    }
    
    
    func initUI() {
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: kNavBarHeight))
        topView.backgroundColor = UIColor.hex(MainColor)
        topView.alpha = 0
        self.topView = topView
        view.addSubview(topView)
        
        let titleLabel = UILabel(frame: CGRect(x: 18, y: 20, width: WIDTH - 18 - 44, height: kNavBarHeight - 20))
        titleLabel.text = "详情"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        topView.addSubview(titleLabel)
        
        leftBtn = UIButton(type: .custom)
        leftBtn.frame = CGRect(x: 0, y: kNavBarHeight - 44, width: 44, height: 44)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        leftBtn.imageView?.contentMode = .scaleToFill
//        leftBtn.setImage(UIImage(named: "navi_back@3x"), for: .normal)
        leftBtn.setTitle("返回", for: .normal)
        leftBtn.setTitleColor(UIColor.white, for: .normal)
        leftBtn.addTarget(self, action: #selector(returnBtnClicked), for: .touchUpInside)
        leftBtn.backgroundColor = UIColor.hex(MainColor)
        leftBtn.layer.cornerRadius = 22
        leftBtn.layer.masksToBounds = true
        view.addSubview(leftBtn)
        
        
        rightBtn = UIButton(frame: CGRect(x: WIDTH - 44 - 10, y: kNavBarHeight - 44, width: 44, height: 44))
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.setTitle("删除", for: .normal)
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.addTarget(self, action: #selector(returnBtnClicked), for: .touchUpInside)
        view.addSubview(rightBtn)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 默认情况下导航栏全透明
        self.topView.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func returnBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addBtnAction() {
        let vc = DiaryEditVC(.story)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StoryListVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取偏移量
        let offset = scrollView.contentOffset.y
        // 改变图片大小
        if offset <= 0 {
            self.imageView.frame = CGRect(x: 0, y: offset, width: WIDTH,
                                          height: imageViewHeight - offset)
        }
        
        // 导航栏背景透明度改变
        var delta =  offset / (imageViewHeight - 64)
        delta = CGFloat.maximum(delta, 0)
        self.topView.alpha = CGFloat.minimum(delta, 1)
        
        // 根据偏移量决定是否显示导航栏标题（上方图片快完全移出时才显示）
        self.title =  delta > 0.9 ? titleStr : ""
        
    }
}

extension StoryListVC: UITableViewDelegate, UITableViewDataSource {
    //在本例中，有1个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            return rowNumber
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let  cell = tableView.dequeueReusableCell(StoryListCell.self, for: indexPath)
            
            return cell
    }
}
