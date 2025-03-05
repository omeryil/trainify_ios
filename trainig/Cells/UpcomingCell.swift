//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit
import Kingfisher

class UpcomingCell: UICollectionViewCell {

    
   
   
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var trainer_name: UILabel!
    @IBOutlet weak var photo: RoundedImage!
    @IBOutlet weak var training_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with upcoming: UpcomingItem){
       
        time.text = upcoming.time
        trainer_name.text = upcoming.trainer_name
        training_name.text = upcoming.training_name
        let imageUrl:String? = upcoming.photo as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            photo.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            photo.image = UIImage(named: "person")
        }
        
    }
    

}
