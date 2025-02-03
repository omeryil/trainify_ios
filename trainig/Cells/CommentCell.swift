//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

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
       
        rating.text = String(comment.rating)
        desc.text = comment.comment
        title.text = comment.username
        icon.image = UIImage(named: comment.photo as! String)
        
    }
    

}
