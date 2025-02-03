//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

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
        photo.image=UIImage(named: upcoming.photo as! String)
        
    }
    

}
