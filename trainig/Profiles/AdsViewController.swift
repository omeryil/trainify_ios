//
//  AdsViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit

class AdsViewController: UIViewController {

    @IBOutlet weak var adsTable: UITableView!
    @IBOutlet weak var picker: UIDatePicker!
    
    var ads: [AdsItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        addData()
        picker.overrideUserInterfaceStyle = .dark
        adsTable.delegate = self
        adsTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    func addData() {
        ads.append(AdsItem(training_name: "Functional Training", _repeat: "Monthly Rep.", price: "800", isActive: true))
        ads.append(AdsItem(training_name: "Flexibility Training", _repeat: "No Rep.", price: "1250", isActive: false))
        ads.append(AdsItem(training_name: "Stretching", _repeat: "Weekly Rep.", price: "750", isActive: true))
        ads.append(AdsItem(training_name: "Balance Training", _repeat: "Daily Rep.", price: "900", isActive: true))
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
extension AdsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "adsCell") as? AdsCell else {
            return UITableViewCell()
        }
        cell.configure(with: ads[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ads.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AdsCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AdsCell {
            cell.backgroundColor = UIColor.clear
          }
    }
}
