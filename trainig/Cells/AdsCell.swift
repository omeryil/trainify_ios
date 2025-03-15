//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit
import SwiftUICore

class AdsCell: UITableViewCell {

    
   
    @IBOutlet weak var isActive: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var _repeat: UILabel!
    @IBOutlet weak var training_name: UILabel!
    @IBOutlet weak var timeStr: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with adsItem: AdsItem){
        training_name.text = adsItem.training_title
        price.text = "₺" + adsItem.price
        let optionalText: String? = adsItem.repetition
        let str : String = String(localized: String.LocalizationValue(optionalText!))
        _repeat.text = str
        timeStr.text = "\(adsItem.start_time!) - \(adsItem.end_time!) ( \(Statics.calculateDuration(adsItem.start_time, adsItem.end_time)) )"
        if adsItem.isActive == true{
            isActive.backgroundColor = .systemGreen
        }else{
            isActive.backgroundColor = .systemRed
        }
      
        
    }
    func configureNoTime(with adsItem: AdsItem){
        training_name.text = adsItem.training_title
        price.text = "₺" + adsItem.price
        let optionalText: String? = adsItem.repetition
        let str : String = String(localized: String.LocalizationValue(optionalText!))
        _repeat.text = str
        timeStr.text = "\(Statics.calculateDuration(adsItem.start_time, adsItem.end_time))"
        if adsItem.isActive == true{
            isActive.backgroundColor = .systemGreen
        }else{
            isActive.backgroundColor = .systemRed
        }
      
        
    }
    

}
