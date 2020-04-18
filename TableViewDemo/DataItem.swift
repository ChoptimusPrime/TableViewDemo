//
//  DataItem.swift
//  TableViewDemo
//
//  Created by Jonathan Compton on 4/17/20.
//  Copyright © 2020 Jonathan Compton. All rights reserved.
//

import Foundation
import UIKit

class DataItem {
    var title: String
    var subtitle: String
    var image: UIImage?
    
    init(title: String, subtitle: String, imageName: String?) {
        self.title = title
        self.subtitle = subtitle
        if let imageName = imageName {
            if let img = UIImage(named: imageName) {
                image = img
            }
        }
    }
}
