//
//  InterestsCell.swift
//  trainig
//
//  Created by omer yildirim on 30.01.2025.
//

import UIKit

class InterestsCell: UICollectionViewCell {

    @IBOutlet weak var interest: UILabel!
    @IBOutlet weak var back: BorderedView!
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
            back.backgroundColor = UIColor(named: "DrkBack")
        }
    }
    func setBack2(with interest_item:InterestItem){
        if interest_item.selected{
            back.backgroundColor = UIColor(named: "MainColor")
        }else{
            back.backgroundColor = UIColor.clear
        }
    }
    func organize(item:CGFloat,color:UIColor){
        let height:CGFloat=self.frame.height;
        back.layer.cornerRadius = height/item
        back.backgroundColor = color
    }
    override init(frame: CGRect) {
            super.init(frame: frame); common() }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder); common() }
        
        private func common() {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                contentView.leftAnchor.constraint(equalTo: leftAnchor),
                contentView.rightAnchor.constraint(equalTo: rightAnchor),
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
}
