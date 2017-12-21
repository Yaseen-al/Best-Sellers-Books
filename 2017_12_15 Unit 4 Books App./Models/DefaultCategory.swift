//
//  Default Settings.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import Foundation
let defaults = UserDefaults.standard
enum DefaultSettingKeys: String {
    case userOne
}
//I am making a default category so I can store the saved default category from the settings ViewController
struct DefaultCategory:Codable {
    var categoryName: String
    var categoryIndex: Int
    var categoryList: [Category]
    mutating func updateCategory(update category: String, with index: Int,and categoryList: [Category]){
        self.categoryName = category
        self.categoryIndex = index
        self.categoryList = categoryList
    }
    static func setCategoryDefault(inputDefault: DefaultCategory){
        if let savedDefaultData = defaults.value(forKey: DefaultSettingKeys.userOne.rawValue) as? Data{
            do{
                let encodedSavedDefault = try PropertyListDecoder().decode(DefaultCategory.self, from: savedDefaultData)
                print("Old Default: ",encodedSavedDefault.categoryName, ", New Default: ", inputDefault.categoryName)
                let encodedDefaulteData = try! PropertyListEncoder().encode(inputDefault)
                defaults.set(encodedDefaulteData, forKey: DefaultSettingKeys.userOne.rawValue)
            }
            catch{
                print("couldn't decode the default data")
            }
            
        }
        else{
            let encodedDefaultData = try! PropertyListEncoder().encode(inputDefault)
            defaults.set(encodedDefaultData, forKey: DefaultSettingKeys.userOne.rawValue)
            print("Saved to defauls")
        }
    }
    static func isEmpty(forDefaultSettingKeys: String)->Bool{
        if (defaults.value(forKey: forDefaultSettingKeys) as? Data) != nil{
            return false
        }else{
            return true
        }
    }
    static func returnValue(inputDefaults: UserDefaults, and key: String)-> DefaultCategory?{
        guard !DefaultCategory.isEmpty(forDefaultSettingKeys: key) else {
            return nil
        }
        let savedDefaultData = inputDefaults.value(forKey: key) as! Data
        let encodedSavedDefault = try! PropertyListDecoder().decode(DefaultCategory.self, from: savedDefaultData)
        return encodedSavedDefault
    }
}
