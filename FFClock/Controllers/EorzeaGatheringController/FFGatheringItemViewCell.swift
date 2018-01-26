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
            let activeSeconds = node.uptime!
            let activeEzBells = Double(activeSeconds) / (ezMinutePerSecond * 60.0)
            let activeText = NSMutableAttributedString.init()
            // 激活时间
            if let times = node.times {
                for ezBell in times {
                    if eorzeaTimer.ezBell >= ezBell && Double(eorzeaTimer.ezBell) <= (Double(ezBell) + activeEzBells) {
                        let realActiveSeconds = (Double(eorzeaTimer.ezBell - ezBell) * 60 + Double(eorzeaTimer.ezMinute)) * ezMinutePerSecond
                        activeText.append(NSAttributedString.init(string: NSString.init(format: "%.0lf ", realActiveSeconds) as String, attributes: [NSForegroundColorAttributeName : UIColor.green]))
                    } else {
                        
                    }
                }
            }
            self.activeLabel.attributedText = activeText
            self.locationLabel.text = self.gatheringItem?.node?.name
        }
    }
}
