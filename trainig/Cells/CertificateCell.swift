//
//  ExperiencesCell.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class CertificateCell: UITableViewCell {

    
   
    @IBOutlet weak var icon: RoundedImage!
    @IBOutlet weak var desc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with certificate: CertificateItem){
        icon.image = UIImage(named: certificate.icon)
        desc.text = String(certificate.description)
    }
    

}
