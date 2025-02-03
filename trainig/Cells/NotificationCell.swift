//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class NotificationCell: UITableViewCell {

    
   
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var tv: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with notification: NotificationItem){
        if notification.type == Notification_Types.Comment{
            icon.image = UIImage(named: "comment")
        }else if notification.type == Notification_Types.Time{
            icon.image = UIImage(named: "time")
        }else if notification.type == Notification_Types.Canceled{
            icon.image = UIImage(named: "canceled")
        }
        var d = Date(timeIntervalSince1970: (Double(notification.createdDate) / 1000.0))
        let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: d, to: Date())
        var str = ""
        if difference.day ?? 0 > 6{
            str = "\(DateFormatter().string(from: d))"
        }else if difference.day ?? 0 > 0{
            str = difference.day.map({ "\($0) d" }) ?? ""
        }else if difference.hour ?? 0 > 0{
            str = difference.hour.map({ "\($0) h" }) ?? ""
        }else if difference.minute ?? 0 > 0{
            str = difference.minute.map({ "\($0) m" }) ?? ""
        }else if difference.second ?? 0 > 0{
            str = "now"
        }
        date.text = str
        desc.text = notification.content
        title.text = notification.title
        
    }
    

}
