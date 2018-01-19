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
        self.refreshTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
            self?.eorzeaTimer.realTimeinterval = Date.init(timeIntervalSinceNow: 0.0).timeIntervalSince1970
            let eozTimer = self?.eorzeaTimer
            self?.timeLabel?.text = String.init(format: "Eorzea Time: %d:%02d", (eozTimer?.ezBell)!, (eozTimer?.ezMinute)!)
            self?._sortNodes()
            self?.tableView.reloadData()
//            self?.tableView.beginUpdates();
//            self?.tableView.reloadRows(at: (self?.tableView.indexPathsForVisibleRows)!, with: UITableViewRowAnimation.none);
//            self?.tableView.endUpdates();
        })
    }
}

extension FFEorzeaGatheringController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.gatheringItems?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "GatheringItem") as? FFGatheringItemViewCell {
            tableViewCell.gatheringItem = self.gatheringItems?[indexPath.row]
            tableViewCell.eorzeaTimer = self.eorzeaTimer
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
            var minAbsTime1 = Int8.max
            node1.times?.forEach({ (time) in
                let absTime1 = currentBell - time
                if absTime1 < minAbsTime1 {
                    minAbsTime1 = absTime1
                }
            })
            var minAbsTime2 = Int8.max
            node2.times?.forEach({ (time) in
                let absTime2 = currentBell - time
                if absTime2 < minAbsTime2 {
                    minAbsTime2 = absTime2
                }
            })
            
            return minAbsTime1 <= minAbsTime2
        })
    }
}
