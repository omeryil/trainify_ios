//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit
import Kingfisher
class UpcomingTableCell: UITableViewCell {

    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var photo: RoundedImage!
    @IBOutlet weak var training_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with upcoming: UpcomingTrainerItem){
        time.text = upcoming.time
        username.text = upcoming.username
        training_name.text = upcoming.training_name
        let imageUrl:String? = upcoming.photo as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            photo.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            photo.image = UIImage(named: "person")
        }
    }
    

}
