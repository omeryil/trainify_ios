//
//  UpdateAboutViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class UpdateAboutViewController: UIViewController {
    var placeholderLabel : UILabel!
    @IBOutlet weak var aboutTextView: CustomTextViewBorder8!
    @IBOutlet weak var countLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTextView.delegate = self
        aboutTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "About Yourself"
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = .systemFont(ofSize: (aboutTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        aboutTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 16, y: 16)
        placeholderLabel.isHidden = !aboutTextView.text.isEmpty
        // Do any additional setup after loading the view.
    }
    
    func updateCharacterCount() {
        let cCount = self.aboutTextView.text.count

        self.countLabel.text = "\((0) + cCount)/1000"
     }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UpdateAboutViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
        self.updateCharacterCount()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count +  (text.count - range.length) <= 1000
    }
}
