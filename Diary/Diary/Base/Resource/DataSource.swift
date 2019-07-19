//
//  DataSource.swift
//  CartoonShow
//
//  Created by 冯才凡 on 2019/6/18.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation

struct DramaModel {
    var name:String = ""
    var tag:String = ""
    var coverUrl:String = ""
    var setsUrls:[String] = []
    
    init(name:String,tag:String,coverUrl:String,setsUrls:[String]) {
        self.name = name
        self.tag = tag
        self.coverUrl = coverUrl
        self.setsUrls = setsUrls
    }
}
