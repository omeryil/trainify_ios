//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit
import Kingfisher
class CommentCell: UITableViewCell {

    
   
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with comment: CommentItem){
       
        rating.text = String(format: "%.1f", comment.rating)
        desc.text = comment.comment
        title.text = comment.username
        
        let imageUrl:String? = comment.photo as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            icon.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            icon.image = UIImage(named: "person")
        }
        
    }
    

}
