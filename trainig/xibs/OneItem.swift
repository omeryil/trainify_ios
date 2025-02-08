//
//  InterestsCell.swift
//  trainig
//
//  Created by omer yildirim on 30.01.2025.
//

import UIKit

class OneItem: UICollectionViewCell {

    @IBOutlet weak var interest: UILabel!
    @IBOutlet weak var back: BorderedViewNoBack8White!
    override func awakeFromNib() {
        super.awakeFromNib()
        interest.sizeToFit()
        // Initialization code
    }
    func configure(with interest_item:InterestItem){
        interest.text = interest_item.interest
        setBack(with: interest_item)
    }
    func setBack(with interest_item:InterestItem){
        if interest_item.selected{
            back.backgroundColor = UIColor(named: "MainColor")
        }else{
            back.backgroundColor = UIColor.clear
        }
    }
    func setBack2(with interest_item:InterestItem){
        if interest_item.selected{
            back.backgroundColor = UIColor(named: "MainColor")
        }else{
            back.backgroundColor = UIColor.clear
        }
    }
    
}
