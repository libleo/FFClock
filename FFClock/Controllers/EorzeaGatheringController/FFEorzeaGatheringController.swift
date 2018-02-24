//
//  FFEorzeaGatheringController.swift
//  FFClock
//
//  Created by leo on 16/01/2018.
//  Copyright © 2018 leo. All rights reserved.
//

import Foundation
import UIKit

class FFEorzeaGatheringController : UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var eorzeaTimer : EorzeaTimer
    var refreshTimer : Timer?
    var gatheringNodes : Array<GatheringNode>?
    var gatheringItems : Array<GatheringItem>?
    
    required init?(coder aDecoder: NSCoder) {
        self.eorzeaTimer = EorzeaTimer.init(timeInterval: 0.0)
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        //
        self._parseNodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshTimer = Timer.init(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.eorzeaTimer.realTimeinterval = Date.init(timeIntervalSinceNow: 0.0).timeIntervalSince1970
            let eozTimer = self?.eorzeaTimer
            self?.timeLabel?.text = String.init(format: "Eorzea Time: %d:%02d", (eozTimer?.ezBell)!, (eozTimer?.ezMinute)!)
            self?._sortNodes()
            self?.tableView.reloadData()
            //            self?.tableView.beginUpdates();
            //            self?.tableView.reloadRows(at: (self?.tableView.indexPathsForVisibleRows)!, with: UITableViewRowAnimation.none);
            //            self?.tableView.endUpdates();
        })
        RunLoop.main.add(self.refreshTimer!, forMode: RunLoopMode.commonModes)
    }
}

extension FFEorzeaGatheringController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.gatheringNodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gatheringNodes?[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.zero)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "GatheringItem") as? FFGatheringItemViewCell {
            let item = self.gatheringNodes?[indexPath.section].items![indexPath.row]
            tableViewCell.eorzeaTimer = self.eorzeaTimer
            tableViewCell.gatheringItem = item
            return tableViewCell
        }
        return UITableViewCell.init()
    }
}

extension FFEorzeaGatheringController {
    fileprivate func _parseNodes() {
        do {
            let data = try Data.init(contentsOf: Bundle.main.url(forResource: "nodes", withExtension: "json")!)
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            var nodesArray = Array<GatheringNode>.init()
            var itemsArray = Array<GatheringItem>.init()
            if let jsonArray = jsonObj as? Array<Dictionary<String, Any>> {
                for jsonDic in jsonArray {
                    if let node = GatheringNode.init(data: jsonDic) {
                        nodesArray.append(node)
                        itemsArray.append(contentsOf: node.items!)
                    }
                }
            }
            self.gatheringNodes = nodesArray
            self.gatheringItems = itemsArray
            self.tableView.reloadData()
        } catch {
            print("parser nodes.json error", error)
        }
    }
    
    fileprivate func _sortNodes() {
        self.gatheringNodes?.sort(by: { [weak self] (node1, node2) -> Bool in
            let currentBell = (self?.eorzeaTimer.ezBell)!
            let currentMinute = (self?.eorzeaTimer.ezMinute)!
            var order1 = 0
            var order2 = 0
            var minAbsTime1 = 10000.0
            node1.times?.forEach({ (time) in
                let absTime1 = Double(time) + Double(node1.uptime ?? 0)/60.0 - (Double(currentBell) + Double(currentMinute)/60.0)
                if absTime1 >= 0 && absTime1 < minAbsTime1 {
                    minAbsTime1 = absTime1
                    node1.statusTime = time
                }
            })
            var minAbsTime2 = 10000.0
            node2.times?.forEach({ (time) in
                let absTime2 = Double(time) + Double(node2.uptime ?? 0)/60.0 - (Double(currentBell) + Double(currentMinute)/60.0)
                if absTime2 >= 0 && absTime2 < minAbsTime2 {
                    minAbsTime2 = absTime2
                    node2.statusTime = time
                }
            })
            
            if currentBell >= node1.statusTime ?? 0 && currentBell < Int8(Int(node1.statusTime ?? 0) + node1.uptime!/60) {
                order1 += 10000
            }
            
            if currentBell >= node2.statusTime ?? 0 && currentBell < Int8(Int(node2.statusTime ?? 0) + node2.uptime!/60) {
                order2 += 10000
            }
            
            if currentBell - Int8(node1.statusTime ?? 0) == -1 {
                order1 += 1000
            }
            
            if currentBell - Int8(node2.statusTime ?? 0) == -1 {
                order2 += 1000
            }
            
            if minAbsTime1 < minAbsTime2 {
                order1 += 1
            } else {
                order2 += 1
            }
            
            return order1 > order2
        })
    }
}
