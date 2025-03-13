//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class OldWeightsCell: UITableViewCell {

    
   
    @IBOutlet weak var date_range: UILabel!
    @IBOutlet weak var changeImage: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var changekg: UILabel!
    @IBOutlet weak var changeper: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with item: OldWeightItem){
        date_range.text = "\(String(localized: "date_range")) : "
        time.text = "\(Statics.formatDateFromLong(timestamp: item.lastTime)) - \(Statics.formatDateFromLong(timestamp: item.time))"
        let kg = item.oldWeight.replacingOccurrences(of: " kg", with: "")
        let oldkg = Int(item.oldWeight.replacingOccurrences(of: " kg", with: ""))!
        let newkg = Int(item.lastWeight.replacingOccurrences(of: " kg", with: ""))!
        if newkg > oldkg {
            let per = (((Double(newkg) - Double(oldkg)) / Double(oldkg))) * 100
            changeper.text = String(format: "%.1f", per) + "%"
            changeImage.image = UIImage(systemName: "arrowshape.up.fill")
        }else if newkg < oldkg {
            let per = (((Double(oldkg) - Double(newkg)) / Double(oldkg))) * 100
            changeper.text = String(format: "%.1f", per) + "%"
            changeImage.image = UIImage(systemName: "arrowshape.down.fill")
        }else {
            let per = 0.0
            changeper.text = String(format: "%.1f", per) + "%"
            changeImage.image = UIImage(systemName: "arrowshape.left.arrowshape.right.fill")
        }
        
        changekg.text = "\(item.oldWeight ?? "") -> \(item.lastWeight ?? "")"
        
    }
    func configure2(newItem: OldWeightItem,oldItem: OldWeightItem){
        date_range.text = "\(String(localized: "date_range")) : "
        time.text = "\(Statics.formatDateFromLong(timestamp: oldItem.time)) - \(Statics.formatDateFromLong(timestamp: newItem.time))"
        let oldkg = Int(oldItem.oldWeight.replacingOccurrences(of: " kg", with: ""))!
        let newkg = Int(oldItem.lastWeight.replacingOccurrences(of: " kg", with: ""))!
        if newkg > oldkg {
            let per = (((Double(newkg) - Double(oldkg)) / Double(oldkg))) * 100
            changeper.text = String(format: "%.1f", per) + "%"
            changeImage.image = UIImage(systemName: "arrowshape.up.fill")
        }else if newkg < oldkg {
            let per = (((Double(oldkg) - Double(newkg)) / Double(oldkg))) * 100
            changeper.text = String(format: "%.1f", per) + "%"
            changeImage.image = UIImage(systemName: "arrowshape.down.fill")
        }else {
            let per = 0.0
            changeper.text = String(format: "%.1f", per) + "%"
            changeImage.image = UIImage(systemName: "arrowshape.left.arrowshape.right.fill")
        }
        changekg.text = "\(oldItem.oldWeight ?? "") -> \(oldItem.lastWeight ?? "")"
        
    }

}
