//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class CalendarCell: UITableViewCell {

    
   
    @IBOutlet weak var isActive: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var training_name: UILabel!
    @IBOutlet weak var trainer_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with item: CalendarItem){
        training_name.text = item.training_name
        trainer_name.text = item.trainer_name
        time.text = item.time
        if item.isActive == true{
            isActive.backgroundColor = .systemGreen
        }else{
            isActive.backgroundColor = .systemRed
        }
        
    }
    

}
