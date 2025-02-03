//
//  GenderCell.swift
//  trainig
//
//  Created by omer yildirim on 29.01.2025.
//

import UIKit

class GenderCell: UICollectionViewCell {
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        lbl.sizeToFit()
    }
    public func configure(with gender: GenderItem) {
        lbl.text = gender.gender
        icon.image = UIImage(named: gender.source)
    }
    public func configureSelect(index:Int,genders:[GenderItem],list:[String])->[GenderItem] {
        var gnd=[GenderItem]()
        for var gender in genders {
            if gender.selected {
                gender.selected = false
                if gender.source.contains("sel_") {
                    gender.source = gender.source.replacingOccurrences(of: "sel_", with: "")
                }
            }
            gnd.append(gender)
        }
        gnd[index].selected = true
        gnd[index].source = "sel_\(list[index])"
        return gnd
    }
}
