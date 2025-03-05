//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit
import Kingfisher
class RecommendedTrainerCell: UITableViewCell {

    
    @IBOutlet weak var trainer_name: UILabel!
    @IBOutlet weak var photo: RoundedImage!
    @IBOutlet weak var exps: UILabel!
    @IBOutlet weak var trainer_title: UILabel!
    @IBOutlet weak var rating: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with recommended: RecommendedTrainerItem){
        exps.text=""
        for i in 0..<recommended.exps.count{
            let str = recommended.exps[i]
            if i < recommended.exps.count-1{
                exps.text?.append("\(str), ")
            }else{
                exps.text?.append("\(str)")
            }
        }
        trainer_name.text = recommended.trainer_name
        trainer_title.text = recommended.trainer_title
        rating.text = String(format: "%.1f", recommended.rating)
        let imageUrl:String? = recommended.photo as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            photo.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            photo.image = UIImage(named: "person")
        }
    }

}
