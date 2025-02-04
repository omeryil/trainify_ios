//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cheked: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with switchItem: SwitchItem){
        title.text = switchItem.title
        cheked.isOn = switchItem.checked
    }
    

}
