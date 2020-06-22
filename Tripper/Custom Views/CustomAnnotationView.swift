//
//  CustomAnnotationView.swift
//  Tripper
//
//  Created by Denis Cherniy on 22.06.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Mapbox

class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    func setUIAppearance(finished: Bool) {
        if finished {
            layer.backgroundColor = UIColor.gray.cgColor
        } else {
            layer.backgroundColor = UIColor.red.cgColor
        }
    }
}
