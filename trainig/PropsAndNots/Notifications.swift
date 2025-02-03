//
//  Notifications.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class Notifications: UITableViewController {

    @IBOutlet var table: UITableView!
    var notifications: [NotificationItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        addData()
        table.delegate=self
        table.dataSource=self
        table.estimatedRowHeight=300
        table.rowHeight = UITableView.automaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func addData() {
        var notificationItem1 = NotificationItem(type: Notification_Types.Comment, title: "Eğitim Başlamak Üzere", createdDate: 1738307789000, content: "Frank Madison ile Alt Bacak Egzersizi 5 dk. içerinde başlayacak.", data: nil)
        notifications.append(notificationItem1)
        notificationItem1 = NotificationItem(type: Notification_Types.Time, title: "Eğitim Başlamak Üzere", createdDate: 1738307789000, content: "Frank Madison ile Alt Bacak Egzersizi 5 dk. içerinde başlayacak.", data: nil)
        notifications.append(notificationItem1)
        notificationItem1 = NotificationItem(type: Notification_Types.Canceled, title: "Eğitim Başlamak Üzere", createdDate: 1738307789000, content: "Frank Madison ile Alt Bacak Egzersizi 5 dk. içerinde başlayacak.", data: nil)
        notifications.append(notificationItem1)
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notifications.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notCell", for: indexPath) as! NotificationCell
        cell.configure(with: notifications[indexPath.row])
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
