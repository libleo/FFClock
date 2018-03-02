//
//  LocalizedText.swift
//  FFClock
//
//  Created by leo on 26/02/2018.
//  Copyright © 2018 leo. All rights reserved.
//

import Foundation

class LocalizedText : NSObject {
    static let shareInstance = LocalizedText()
    
    var currentLocale = "cn"
    
    var cnTextMap : Dictionary<String, String>
    
    override private init() {
        do {
            let data = try Data.init(contentsOf: Bundle.main.url(forResource: "locale.cn", withExtension: "json")!)
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let textMap = jsonObj as? Dictionary<String, String> {
                self.cnTextMap = textMap
            } else {
                self.cnTextMap = Dictionary<String, String>.init()
            }
        } catch {
            print("parser locale error", error)
            self.cnTextMap = Dictionary<String, String>.init()
        }
    }
    
    func currentLocaleTextMap() -> Dictionary<String, String>? {
        let map = self.value(forKey: self.currentLocale + "TextMap") as? Dictionary<String, String>
        return map
    }
}
