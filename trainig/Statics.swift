//
//  Statics.swift
//  trainig
//
//  Created by omer yildirim on 12.02.2025.
//

import Foundation
import UIKit

public class Statics {
    public static let tokentimeMax:TimeInterval=60*60*24*1000
//    public static let host="http://192.168.0.26/"
    public static let host="http://37.148.212.114/"
    public static let osService="http://37.148.212.114:5002/"
    public static let intList:[String] = ["Yoga",
                                          "Hatha Yoga",
                                          "Vinyasa",
                                          "Ashtanga Yoga",
                                          "Kundalini Yoga",
                                          "Nefes Egzersizi",
                                          "Meditasyon",
                                          "Pilates",
                                          "Modern Pilates",
                                          "Mat Pilates Workout",
                                          "Reformer Pilates Workout",
                                          "HIIT Workout",
                                          "Plyometric Training",
                                          "Interval Training",
                                          "Weight Training",
                                          "Functional Training",
                                          "Zumba",
                                          "Acro Yoga",
                                          "Trx Training",
                                          "4d Pro Trainig",
                                          "Step Aerobik Fitness",
                                          "Bosu Training",
                                          "Rope Jump",
                                          "Resistance Band Workout",
                                          "Cross Fit Training",
                                          "Fitness",
                                          "Home Ftiness",
                                          "Balance Training",
                                          "Endurance" ]
    
    public static func yearsDifference(from timestamp: TimeInterval) -> String? {
        let calendar = Calendar.current
        let fromDate = Date(timeIntervalSince1970: timestamp/1000)
        let toDate = Date()
        
        let components = calendar.dateComponents([.year], from: fromDate, to: toDate)
        let diff:String=String(components.year ?? 0)
        return diff
    }
    public static func checkMinsDifference(from timestamp: TimeInterval,maxDiff:Int=3) -> Bool {
        let calendar = Calendar.current
        let fromDate = Date(timeIntervalSince1970: timestamp/1000)
        let toDate = Date()
        
        let components = calendar.dateComponents([.minute], from: fromDate, to: toDate)
        let diff = components.minute! >= 3 ? true : false
        return diff
    }
    public static func checkSecondsDifference(from timestamp: TimeInterval) -> Bool {
        let calendar = Calendar.current
        let fromDate = Date(timeIntervalSince1970: timestamp/1000)
        let toDate = Date()
        
        let components = calendar.dateComponents([.second], from: fromDate, to: toDate)
        let diff = components.second! >= Int(Statics.tokentimeMax) ? true : false
        return diff
    }
    public static func yearsDifferenceInt(from timestamp: TimeInterval) -> Int? {
        let calendar = Calendar.current
        let fromDate = Date(timeIntervalSince1970: timestamp/1000)
        let toDate = Date()
        
        let components = calendar.dateComponents([.year], from: fromDate, to: toDate)
        let diff = components.year ?? 0
        return diff
    }
    public static func currentTimeInMilliSeconds()-> Int64
    {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int64(since1970 * 1000)
    }
    public static func currentTimeInMilliSeconds(date:Date)-> Int64
    {
        let currentDate = date
        let since1970 = currentDate.timeIntervalSince1970
        return Int64(since1970 * 1000)
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
    public static func calculateHourDifference(dateString:String,hour:Int) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        if let date = dateFormatter.date(from: dateString) {
            let now = Date()
            let difference = Calendar.current.dateComponents([.hour], from: now, to: date)
            return difference.hour! >= hour
        } else {
            return false
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
    public static func formatDateWithTimeFromLong(timestamp: Int64) -> String
    {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp)/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.string(from: date)
    }
    public static func formatDateFromLong(timestamp: Int64) -> String
    {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp)/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    public static func formatTimeFromLong(timestamp: Int64) -> String
    {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp)/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    public static func getTimeDifference(start: Int64,end:Int64) -> String
    {
        let startDate = Date(timeIntervalSince1970: TimeInterval(start)/1000)
        let endDate = Date(timeIntervalSince1970: TimeInterval(end)/1000)
        let timeDifference = endDate.timeIntervalSince(startDate)
        let minutes = Int(timeDifference) / 60
        return formatMinutesToHoursMinutes(minutes);
        
    }
    public static func formatMinutesToHoursMinutes(_ totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 && minutes > 0 {
            let hstr = hours == 1 ? String(localized: "hour") : String(localized: "hours")
            let minstr = minutes == 1 ? String(localized: "min") : String(localized: "mins")
            return "\(hours) \(hstr) \(minutes) \(minstr)"
        } else if hours > 0 {
            let hstr = hours == 1 ? String(localized: "hour") : String(localized: "hours")
            return "\(hours) \(hstr)"
        } else {
            let minstr = minutes == 1 ? String(localized: "min") : String(localized: "mins")
            return "\(minutes) \(minstr)"
        }
    }
    public static func calculateDuration(_ start_time:String,_ end_time:String) -> String {
        let start=start_time.components(separatedBy: ":")
        let end = end_time.components(separatedBy: ":")
        let starttime = Int(start[0])!*60+Int(start[1])!
        let endtime = Int(end[0])!*60+Int(end[1])!
        return Statics.formatMinutesToHoursMinutes(endtime - starttime)
    }
    public static func longDateTimestamp(fromAge age: Int) -> Int64 {
        let calendar = Calendar.current
        let currentDate = Date()
        if let birthDate = calendar.date(byAdding: .year, value: -age, to: currentDate) {
            let timestampInSeconds = birthDate.timeIntervalSince1970
            return Int64(timestampInSeconds * 1000)
        }
        
        return 0
    }
    public static func createDate(year: Int, month: Int, day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: "\(year)/\(month)/\(day)")!
    }
    public static func createDate(d:String) -> Date {
        let formatter = DateFormatter()
        let ts = d.components(separatedBy: "T")
        let ds = ts[0].components(separatedBy: "-")
        let ns = "\(ds[2])/\(ds[1])/\(ds[0]) \(ts[1])"
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.date(from: ns)!
    }
    public static func convertToTimestamp(dateString: String) -> Int64? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        if let date = dateFormatter.date(from: dateString) {
            // Convert to milliseconds (or use `timeIntervalSince1970` for seconds)
            let timestamp = Int64(date.timeIntervalSince1970 * 1000)
            return timestamp
        }
        
        return nil
    }
}
