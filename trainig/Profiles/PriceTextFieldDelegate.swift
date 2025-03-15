//
//  PriceTextFieldDelegate.swift
//  trainig
//
//  Created by omer yildirim on 14.03.2025.
//

import UIKit


class PriceTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // Ensures the integer is formatted without decimal places
            formatter.maximumFractionDigits = 0 // Disables any fractional digits
            formatter.usesGroupingSeparator = false // Disables thousands separators (commas)
            return formatter
        }()
    func textFieldDidChangeSelection(_ textField: UITextField) {
            // Eğer metin 4 karakteri geçiyorsa, 4 karakterle sınırlı tutuyoruz
            if let text = textField.text, text.count > 4 {
                textField.text = String(text.prefix(4)) // Sadece ilk 4 karakteri al
            }
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // Get the current text and the new text input
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Remove any non-numeric characters (including comma)
            let allowedCharacters = CharacterSet(charactersIn: "0123456789") // Only digits
            let cleanedText = newText.components(separatedBy: allowedCharacters.inverted).joined()

            // Check if the cleaned text can be converted to an integer
            if let number = Int(cleanedText) {
                textField.text = numberFormatter.string(from: NSNumber(value: number)) // Format the integer without decimals
            } else {
                textField.text = "" // Clear the text if it's invalid input
            }
            
            return false // Prevent manual entry
        }
}
