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
    
    private var _isExpanded = false;
    
    var isExpanded: Bool {
        get {
            _isExpanded
        }
        set {
            _isExpanded = newValue
            configureUIVisibility()
        }
    }
    
    // MARK: - UITableViewCell's Delegates
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUIVisibility()
//        descriptionTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
    }
    
    // MARK: - Helper Methods
    
    func configure(for subroute: Subroute) {
        let staying = subroute as! Staying
        titleLabel.text = String(staying.title)
        timeLabel.text = format(minutes: staying.timeInMinutes)
        descriptionTextView.text = staying.description
    }
    
    func configureUIVisibility() {
        if isExpanded {
            self.descriptionTextView.isHidden = false
            self.descriptionTitleLabel.isHidden = false
            
//            UIView.animate(withDuration: 1, animations: {
//            self.descriptionTextView.textColor = UIColor(white: 0, alpha: 1)
//            self.descriptionTitleLabel.textColor = UIColor(white: 0, alpha: 1)
//            })
        } else {
//            UIView.animate(withDuration: 1, animations: {
//                    self.descriptionTextView.textColor = UIColor(white: 0, alpha: 0)
//                    self.descriptionTitleLabel.textColor = UIColor(white: 0, alpha: 0)
//            }, completion: { _ in
                self.descriptionTextView.isHidden = true
                self.descriptionTitleLabel.isHidden = true
//            })
            
        }
        
    }
    
}
