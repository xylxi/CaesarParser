//
//  AppDelegate.swift
//  ReadCaesarParseRecord
//
//  Created by WangZHW on 16/1/13.
//  Copyright © 2016年 RobuSoft. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let json = Person.getJSON()
        let mingge = Person(json: json)
        let obj = mingge.toJSONObject()
        print("obj-->\n\(obj)\(obj.dynamicType)")
//        var gP: Person? = nil
//        let obj: JSONObject = json
//        
//        gP <-- obj
//        print(gP)
//        let type = gP.dynamicType
//        print(String(type))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

/**
 枚举类型，原始值类型是Int
 好像是都默认遵守了RawRepresentable协议
 */
enum Gender: Int {
    case Unknown = 0
    case Male = 1
    case Female = 2
}

class Person: Deserializable, Serializable {
    var name: String = "xiaoming"
    var date: NSDate?
    var age: Int?
    var birthday: Double?
    var weight: Float?
    var adult: Bool = false
    var gender: Gender = .Unknown
    var girlFriend: Person?
    var luckyNumbers = [Int]()
    var preferNumbers : [Int: Int]?
    
    static func getJSON() ->[String : AnyObject] {
        let json = [
            "age"  : 24,
            "date" : "2016-01-12 15:12",
            "birthday" : 1212,
            "weight" : 180.0,
            "adult" : true,
            "gender" : 1,
            "girlFriend" :
            [
                "name" : "spx",
                "age"  : 24,
                "birthday" : 1212,
                "weight" : 120.0,
                "adult" : true
            ],
            "luckyNumbers" : [1,2,3,4,5],
            "preferNumbers" :
            [
                "1" : 1,
                "2" : 2,
                "3" : 3,
                "4" : 4
            ]
        ]
        return json
    }
    
    required init(json: JSONDictionary) {
        name <-- json["name"]
        age <-- json["age"]
        date <-- (json["date"], DateFormatConverter("yyyy-MM-dd hh:mm"))
        birthday <-- json["birthday"]
        weight <-- json["weight"]
        adult <-- json["adult"]
        gender <-- json["gender"]
        girlFriend <-- json["girlFriend"]
        luckyNumbers <-- json["luckyNumbers"]
        preferNumbers <-- json["preferNumbers"]
    }
    
    func toJSONObject() -> JSONObject {
        var json = JSONDictionary()
        name --> json["name"]
        age --> json["age"]
        birthday --> json["birthday"]
        weight --> json["weight"]
        adult --> json["adult"]
        gender --> json["gender"]
        girlFriend --> json["girlFriend"]
        luckyNumbers --> json["luckyNumbers"]
        preferNumbers --> json["preferNumbers"]
        return json
    }
}









