//
//  GenderItem.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import Foundation
import UIKit

enum Notification_Types {
    case Time
    case Comment
    case Canceled
 }

struct NotificationItem {
    var type: Notification_Types!
    var title: String!
    var createdDate: Int64!
    var content: String!
    var data: [String: Any]!
}
