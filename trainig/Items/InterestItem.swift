//
//  GenderItem.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import Foundation
import UIKit

public class InterestItem: Codable{
    var interest: String!
    var selected: Bool!
    
    init(interest: String!, selected: Bool!) {
        self.interest = interest
        self.selected = selected
    }
}
