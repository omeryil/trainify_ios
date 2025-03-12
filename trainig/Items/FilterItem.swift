//
//  GenderItem.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import Foundation
import UIKit


struct FilterItem {
    var training_type:[String]=[]
    var gender:[String]=[]
    var priceRange: [CGFloat]=[]
    var ageRange: [CGFloat]=[]
    var experience:[[Int]]=[]
    
    static func == (lhs: FilterItem, rhs: FilterItem) -> Bool {
            return lhs.training_type == rhs.training_type && lhs.gender == rhs.gender && lhs.priceRange == rhs.priceRange && lhs.ageRange == rhs.ageRange && lhs.experience == rhs.experience
        }
}
