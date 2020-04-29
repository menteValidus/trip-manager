//
//  StayingCell.swift
//  Tripper
//
//  Created by Denis Cherniy on 04.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit
import Foundation

class StayingCell: UITableViewCell, SubrouteCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    // MARK: - UITableViewCell's Delegates
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Helper Methods
    
    func configure(for subroute: Subroute) {
        let staying = subroute as! Staying
        titleLabel.text = String(staying.title)
        timeLabel.text = format(seconds: staying.timeInSeconds)
        descriptionTextView.text = staying.description
    }
}
