//
//  SubrouteCell.swift
//  Tripper
//
//  Created by Denis Cherniy on 04.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class RoadCell: UITableViewCell, SubrouteCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Helper Methods
    
    func configure(for subroute: Subroute) {
        titleLabel.text = subroute.title
        let timeString = format(seconds: subroute.timeInSeconds)
        timeLabel.text = timeString.isEmpty ? "Several seconds" : timeString
    }
}
