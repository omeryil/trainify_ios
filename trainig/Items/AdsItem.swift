//
//  GenderItem.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import Foundation
import UIKit


struct AdsItem {
    var training_title: String!
    var repetition: String!
    var price: String!
    var start_time: String!
    var end_time: String!
    var record_id: String!
    var isActive: Bool!
    var equipments:String!
    var date:String!
    
    func toNSDictionary() -> NSMutableDictionary {
        return [
            "training_title": training_title!,
            "repetition": repetition!,
            "isActive": isActive!,
            "price": price!,
            "start_time": start_time!,
            "end_time": end_time!,
            "record_id": record_id!,
            "equipments": equipments!,
            "date": date!
        ]
    }
}
