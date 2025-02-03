//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class AdsCell: UITableViewCell {

    
   
    @IBOutlet weak var isActive: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var _repeat: UILabel!
    @IBOutlet weak var training_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with adsItem: AdsItem){
        training_name.text = adsItem.training_name
        price.text = "₺" + adsItem.price
        _repeat.text = adsItem._repeat
        if adsItem.isActive == true{
            isActive.backgroundColor = .systemGreen
        }else{
            isActive.backgroundColor = .systemRed
        }
      
        
    }
    

}
