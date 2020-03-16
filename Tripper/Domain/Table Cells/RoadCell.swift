//
//  SubrouteCell.swift
//  Tripper
//
//  Created by Denis Cherniy on 04.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class RoadCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    func configure(for inRoadSubroute: InRoad) {
        titleLabel.text = inRoadSubroute.title
        timeLabel.text = String(inRoadSubroute.timeInMinutes)
    }

}
