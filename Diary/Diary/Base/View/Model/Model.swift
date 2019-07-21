//
//  Model.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation
import RealmSwift

//日记基础类
class DiaryItemModel: Object {
    @objc dynamic var title:String = "" //标题
    @objc dynamic var detail:String = "" //正文
    @objc dynamic var time:Int = 0 //时间
    
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }

    //修改的话，只能修改正文
    func modify(_ detail:String) {
        let realm = try! Realm()
        // 先根据时间查找到数据库中的对象，然后进行修改
        if let origin = realm.objects(DiaryItemModel.self).filter("time ==  \(self.time)").first {
            try! realm.write {
                origin.detail = detail
            }
        }
    }

    //删除当前对象
    func delete(_ complete:((_ result:Bool)->Void)?) {
        let realm = try! Realm()
        // 先查找到数据库中的对象，然后进行修改
        if let origin = realm.objects(DiaryItemModel.self).filter("time ==  \(self.time)").first {
            try! realm.write {
                realm.delete(origin)
            }
            complete?(true)
        }else{
            complete?(false)
        }
    }
}

// 一个月的记录
class MonthDiaryModel {
    var monthStr:String = ""
    var list:[DiaryItemModel] = [] //每一天的记录
}

//故事本章节基础类
class StoryItemModel:Object {
    @objc dynamic var title:String = ""
    @objc dynamic var detail:String = ""
    @objc dynamic var time:Int = 0
    @objc dynamic var BookName:String = ""
//    
//    
//    func save() {
//        let realm = try! Realm()
//        try! realm.write {
//            realm.add(self)
//        }
//    }
//    
//    //修改的话，只能修改正文
//    func modify(_ detail:String) {
//        let realm = try! Realm()
//        // 先根据时间查找到数据库中的对象，然后进行修改
//        if let origin = realm.objects(DiaryItemModel.self).filter("time ==  \(self.time)").first {
//            try! realm.write {
//                origin.detail = detail
//            }
//        }
//    }
//    
//    //删除当前对象
//    func delete(_ complete:((_ result:Bool)->Void)?) {
//        let realm = try! Realm()
//        // 先查找到数据库中的对象，然后进行修改
//        if let origin = realm.objects(DiaryItemModel.self).filter("time ==  \(self.time)").first {
//            try! realm.write {
//                realm.delete(origin)
//            }
//            complete?(true)
//        }else{
//            complete?(false)
//        }
//    }
}

//故事本基础类
class StoryBookItem: Object {
    var storys = List<StoryItemModel>()
    @objc dynamic var title:String = ""
    @objc dynamic var time:Int = 0
    @objc dynamic var des:String = ""
    @objc dynamic var imgName:String = ""
    func save() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self)
        }
    }
    
    //修改的话，只能修改描述
    func modify(_ des:String) {
        let realm = try! Realm()
        // 先根据时间查找到数据库中的对象，然后进行修改
        if let origin = realm.objects(StoryBookItem.self).filter("time ==  \(self.time)").first {
            try! realm.write {
                origin.des = des
            }
        }
    }
    
    //删除当前对象
    func delete(_ complete:((_ result:Bool)->Void)?) {
        let realm = try! Realm()
        // 先查找到数据库中的对象，然后进行修改
        if let origin = realm.objects(StoryBookItem.self).filter("time ==  \(self.time)").first {
            try! realm.write {
                realm.delete(origin)
            }
            complete?(true)
        }else{
            complete?(false)
        }
    }
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

// 时间转成年月
func timeOnlyToDStr(_ s:TimeInterval) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = "dd"
    let date = Date(timeIntervalSince1970: s)
    return dateformat.string(from: date)
}

// 时间转成年月
func timeOnlyToTStr(_ s:TimeInterval) -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = "yyyy-MM HH:mm:ss"
    let date = Date(timeIntervalSince1970: s)
    return dateformat.string(from: date)
}

//更加时间获取星期
func getTodayWeekDay(_ s:TimeInterval)-> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let date = Date(timeIntervalSince1970: s)
    let weekDay = dateFormatter.string(from: date)
    return weekDay
}
