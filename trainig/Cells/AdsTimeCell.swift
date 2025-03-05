//
//  InterestsCell.swift
//  trainig
//
//  Created by omer yildirim on 30.01.2025.
//

import UIKit

class AdsTimeCell: UICollectionViewCell {

    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var back: BorderedView!
    override func awakeFromNib() {
        super.awakeFromNib()
        item.sizeToFit()
        // Initialization code
    }
    func configure(with i:AdsTimeItem){
        item.text = i.item
        setBack(with: i)
    }
    func setBack(with i:AdsTimeItem){
        if i.selected{
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
