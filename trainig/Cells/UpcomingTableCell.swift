//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

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
        duration.text = upcoming.duration
        username.text = upcoming.username
        training_name.text = upcoming.training_name
        photo.image=UIImage(named: upcoming.photo as! String)
    }
    

}
