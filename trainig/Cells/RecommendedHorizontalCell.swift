//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class RecommendedHorizontalCell: UICollectionViewCell {

    
   
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var trainer_name: UILabel!
    @IBOutlet weak var photo: RoundedImage!
    @IBOutlet weak var training_name: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var rating: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with recommended: RecommendedItem){
        time.text = recommended.time
        trainer_name.text = recommended.trainer_name
        training_name.text = recommended.training_name
        duration.text = recommended.duration
        rating.text = String(recommended.rating)
        photo.image=UIImage(named: recommended.photo as! String)
        
    }
    

}
