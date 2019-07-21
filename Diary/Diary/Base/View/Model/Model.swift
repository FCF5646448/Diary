//
//  Model.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation

//日记基础类
class DiaryItemModel {
    var title:String = ""
    var detail:String = ""
    var time:Int = 0
    var fontName:String = ""
    var fontSize:Int = 14
    var color:Int32 = 0x5a5a5a //
    
//    func save() {
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(self)
//        }
//    }
//
//    //修改的话，只能修改价格
//    func modify(_ price:String) {
//        let realm = try! Realm()
//        // 先查找到数据库中的对象，然后进行修改
//        if let origin = realm.objects(CostItemModel.self).filter("time ==  \(self.time)").first {
//            try! realm.write {
//                origin.price = price
//            }
//        }
//    }
//
//    //删除当前对象
//    func delete(_ complete:((_ result:Bool)->Void)?) {
//        let realm = try! Realm()
//        // 先查找到数据库中的对象，然后进行修改
//        if let origin = realm.objects(CostItemModel.self).filter("time ==  \(self.time)").first {
//            try! realm.write {
//                realm.delete(origin)
//            }
//            complete?(true)
//        }else{
//            complete?(false)
//        }
//    }
}

//日记基础类
class StoryItemModel {
    var title:String = ""
    var detail:String = ""
    var time:Int = 0
    var fontName:String = ""
    var fontSize:Int = 14
    var color:Int32 = 0x5a5a5a //
}

class StoryBookItem {
    var storys:[StoryItemModel] = []
    var title:String = ""
    var des:String = ""
    var imgName:String = ""
}


// 一个月的记录
class MonthDiaryModel {
    var monthStr:String = ""
    var dayStr:String = ""
    var list:[DiaryItemModel] = [] //每一天的记录
}

func currentTimeSecond() ->TimeInterval {
    return Date().timeIntervalSince1970
}

// 时间转成完整字符串
func timeToStr(_ s:TimeInterval) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = "yyyy.MM.dd HH:mm:ss"
    let date = Date(timeIntervalSince1970: s)
    return dateformat.string(from: date)
}
// 时间转成年月日
func timeToDStr(_ s:TimeInterval) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = "yyyy.MM.dd"
    let date = Date(timeIntervalSince1970: s)
    return dateformat.string(from: date)
}
// 时间转成年月
func timeToMStr(_ s:TimeInterval) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = "yyyy.MM"
    let date = Date(timeIntervalSince1970: s)
    return dateformat.string(from: date)
}
// 时间转成完整字符串
func timeToHStr(_ s:TimeInterval) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = "HH:mm:ss"
    let date = Date(timeIntervalSince1970: s)
    return dateformat.string(from: date)
}

// 时间转成年月
func timeOnlyToMStr(_ s:TimeInterval) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = "MM"
    let date = Date(timeIntervalSince1970: s)
    return dateformat.string(from: date)
}
