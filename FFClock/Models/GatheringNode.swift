//
//  GatheringNode.swift
//  FFClock
//
//  Created by leo on 16/01/2018.
//  Copyright © 2018 leo. All rights reserved.
//

import Foundation
import CoreGraphics

//{
//    "item": "Dark Matter Cluster",
//    "icon": 5899,
//    "id": 10335,
//    "slot": "?"
//}

public class GatheringItem {
    var itemName : String?
    var itemNameRaw : String?
    var itemIden : Int?
    var itemIconIden : Int?
    var node : GatheringNode?
    var slot : String?
    
    init?(data aData : Dictionary<String, Any>, node aNode: GatheringNode) {
        self._parseData(data: aData)
        self.node = aNode
    }
    
    private func _parseData(data aData : Dictionary<String, Any>) -> Void {
        self.itemNameRaw = aData["item"] as? String
        let map = LocalizedText.shareInstance.currentLocaleTextMap()
        self.itemName = map?[self.itemNameRaw!] ?? self.itemNameRaw
        self.itemIden = aData["id"] as? Int
        self.itemIconIden = aData["icon"] as? Int
        self.slot = aData["slot"] as? String
    }
}

//"stars": 2,
//"time": [
//3
//],
//"title": "Raubahn's Push",
//"zone": "Northern Thanalan",
//"coords": [
//17,
//20
//],
//"name": "Unspoiled",
//"uptime": 180,
//"lvl": 50,
//"id": 236,
//"patch": 2.0

enum GatheringNodeStatus {
    case GatheringNodeStatusNone
    case GatheringNodeStatusActive
    case GatheringNodeStatusPending
}

public class GatheringNode {
    
    var title : String?
    var name : String?
    var iden : NSNumber?
    var stars : Int8?
    var times : Array<Int8>?
    var coords : CGPoint?
    var uptime : Int?
    var level : Int8?
    var patch : Float?
    var items : Array<GatheringItem>?
    
    var gatheringStatus : GatheringNodeStatus?
    var statusTime : Int8?
    
    init?(data aData : Dictionary<String, Any>) {
        self._parseData(data: aData)
    }
    
    private func _parseData(data aData : Dictionary<String, Any>) -> Void {
        self.title = aData["title"] as? String
        self.name = aData["name"] as? String
        self.iden = aData["id"] as? NSNumber
        self.stars = aData["stars"] as? Int8
        
        var tmpTimes : Array<Int8> = Array<Int8>.init()
        if let times = aData["time"] as? Array<Int8> {
            for time in times {
                tmpTimes.append(time)
                tmpTimes.append(time + 24)
            }
        }
        self.times = tmpTimes
        
        if let coordsArray = aData["coords"] as? Array<NSNumber> {
            self.coords = CGPoint.init(x: coordsArray[0].intValue, y: coordsArray[1].intValue)
        }
        
        self.uptime = aData["uptime"] as? Int
        self.level = aData["lvl"] as? Int8
        self.patch = aData["patch"] as? Float
        
        var tmpArray = Array<GatheringItem>.init()
        if let itemsArray = aData["items"] as? Array<Dictionary<String, Any>> {
            for itemDic in itemsArray {
                if let item = GatheringItem.init(data: itemDic, node: self) {
                    tmpArray.append(item)
                }
            }
            self.items = tmpArray
        }
    }
}
