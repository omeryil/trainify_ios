//
//  AdsViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class CalendarController: UIViewController {

    @IBOutlet weak var calendarTable: UITableView!
    @IBOutlet weak var picker: UIDatePicker!
    
    var items: [CalendarItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        addData()
        picker.overrideUserInterfaceStyle = .dark
        calendarTable.delegate = self
        calendarTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    func addData() {
        items.append(CalendarItem(trainer_name: "Frank Madison", training_name: "Functional Training", time: "01/03/2025 11:30 - 12:30", isActive: true))
        items.append(CalendarItem(trainer_name: "Frank Madison", training_name: "Functional Training", time: "01/03/2025 11:30 - 12:30", isActive: true))
        items.append(CalendarItem(trainer_name: "Frank Madison", training_name: "Functional Training", time: "01/03/2025 11:30 - 12:30", isActive: true))
        items.append(CalendarItem(trainer_name: "Frank Madison", training_name: "Functional Training", time: "01/03/2025 11:30 - 12:30", isActive: true))
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
extension CalendarController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cCell") as? CalendarCell else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CalendarCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CalendarCell {
            cell.backgroundColor = UIColor.clear
          }
    }
}
