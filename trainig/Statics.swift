//
//  Statics.swift
//  trainig
//
//  Created by omer yildirim on 12.02.2025.
//

import Foundation
import UIKit

public class Statics {
    public static let host="http://192.168.0.26/"
    public static let osService="http://192.168.0.26:5002/"
    
    public static func yearsDifference(from timestamp: TimeInterval) -> String? {
        let calendar = Calendar.current
        let fromDate = Date(timeIntervalSince1970: timestamp/1000)
        let toDate = Date()
        
        let components = calendar.dateComponents([.year], from: fromDate, to: toDate)
        let diff:String=String(components.year ?? 0)
        return diff
    }
    public static func currentTimeInMilliSeconds()-> Int
    {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    public static func saveImageToTempDirectory(image: UIImage) -> URL? {
        let fileName = UUID().uuidString + ".jpg"
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(fileName)

        if let imageData = image.jpegData(compressionQuality: 0.8) {
            do {
                try imageData.write(to: fileURL)
                print("📂 Saved edited image to: \(fileURL)")
                return fileURL
            } catch {
                print("❌ Error saving image: \(error)")
            }
        }
        return nil
    }
    public static func convertStringDateToTime(dateString:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: dateString) {
            let timestamp = Int(date.timeIntervalSince1970*1000)
            return timestamp
        } else {
            return 0
        }
    }
    public static func createDatePicker(tf:UITextField?,pickerToolbar:UIToolbar) -> UIDatePicker {
        var datePicker: UIDatePicker!
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 300)
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.minimumDate = Date()
        tf!.inputAccessoryView = pickerToolbar
        frameView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        tf!.inputView = frameView
        return datePicker
    }
    public static func createTimePicker(tf:UITextField?,pickerToolbar:UIToolbar) -> UIDatePicker {
        var datePicker: UIDatePicker!
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 300)
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        tf!.inputAccessoryView = pickerToolbar
        //datePicker.minimumDate = Date()
        frameView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        tf!.inputView = frameView
        return datePicker
    }
    public static func createUIToolBar() -> UIToolbar{
        let pickerToolbar: UIToolbar = UIToolbar()
        pickerToolbar.autoresizingMask = .flexibleHeight
        pickerToolbar.layer.cornerRadius = 10

        pickerToolbar.barStyle = .default
        pickerToolbar.barTintColor = UIColor(named: "DarkBack")
        pickerToolbar.backgroundColor = UIColor.white
        pickerToolbar.isTranslucent = false
        
        return pickerToolbar
    }
    public static func createPickerView(tf:UITextField,pickerToolbar:UIToolbar) -> UIPickerView {
        let wPicker: UIPickerView = UIPickerView()
        let frameView = UIView()
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = UIColor(named: "DarkBack")
        frameView.frame.size = CGSize(width: 0, height: 200)
        frameView.addSubview(wPicker)
        wPicker.setValue(UIColor.white, forKeyPath: "textColor")
        wPicker.translatesAutoresizingMaskIntoConstraints = false
        wPicker.topAnchor.constraint(equalTo: frameView.topAnchor).isActive = true
        wPicker.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        wPicker.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        wPicker.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        tf.inputView = frameView
        tf.inputAccessoryView = pickerToolbar
        return wPicker
    }
    public static func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
}
