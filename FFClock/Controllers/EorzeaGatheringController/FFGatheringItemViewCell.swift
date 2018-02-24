//
//  FFGatheringItemCellView.swift
//  FFClock
//
//  Created by leo on 16/01/2018.
//  Copyright © 2018 leo. All rights reserved.
//

import Foundation
import UIKit

class FFGatheringItemViewCell : UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var scripImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var eorzeaTimer: EorzeaTimer?
    
    var gatheringItem : GatheringItem? {
        willSet {
        }
        didSet {
            self.refreshDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        
    }
    
    public func refreshDisplay() {
        if let node = self.gatheringItem?.node, let eorzeaTimer = self.eorzeaTimer {
            self.nameLabel.text = self.gatheringItem?.itemName
            let activeSeconds = Double(node.uptime!) * ezMinutePerSecond
            let activeEzBells = Double(activeSeconds) / 60.0
            let activeText = NSMutableAttributedString.init()
            // 激活时间
            if let time = node.statusTime {
                if eorzeaTimer.ezBell >= time && Double(eorzeaTimer.ezBell) <= (Double(time) + activeEzBells) {
                    let realActiveSeconds = (Double(eorzeaTimer.ezBell - time) * 60 + Double(eorzeaTimer.ezMinute)) * ezMinutePerSecond + eorzeaTimer.realTimeRemainder
                    let reminderSecond = Double(activeSeconds) - realActiveSeconds;
                    activeText.append(NSAttributedString.init(string: NSString.init(format: "%.0lf ", reminderSecond) as String, attributes: [NSForegroundColorAttributeName : UIColor.green]))
                } else if eorzeaTimer.ezBell - time == -1 {
                    let willActiveSeconds = (Double(time - eorzeaTimer.ezBell) * 60 - Double(eorzeaTimer.ezMinute)) * ezMinutePerSecond - eorzeaTimer.realTimeRemainder
                    activeText.append(NSAttributedString.init(string: NSString.init(format: "%.0lf ", willActiveSeconds) as String, attributes: [NSForegroundColorAttributeName : UIColor.red]))
                } else {
                    
                }
            }
            self.activeLabel.attributedText = activeText
            self.locationLabel.text = self.gatheringItem?.node?.name
        }
    }
}
