//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class ExperiencesCell: UITableViewCell {

    @IBOutlet weak var exp: UILabel!
    @IBOutlet weak var yrs: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with experience: ExperiencesItem){
        exp.text = experience.experience
        yrs.text = String(experience.year) + " " + String(localized: "yrs")
    }
    func configureYear(with year: String){
        yrs.text = year
    }

}
