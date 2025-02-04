//
//  ShowItems.swift
//  trainig
//
//  Created by omer yildirim on 4.02.2025.
//

import UIKit

class ShowItems: UITableViewController {

    var items:[ForwardItem]=[]
    var names:[String]=["Notifications","Update Personal Info","Settings","Update About","Update Interests","Update Profile Photo","Update Trainer Video","Update Certificate","User Profile","Trainer Profile(UserSide)","Trainer Profile(TrainerSide)","Search","Search Result","User Home","Add Certificate","Add Experience","User Interests","Trainer Ads"]
    var controllers:[Any] = [Notifications.self , UpdatePersonalViewController.self]
    override func viewDidLoad() {
        super.viewDidLoad()
        addForward()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func addForward() {
        
        let pi = storyboard?.instantiateViewController(withIdentifier: "pi") as! PersonalInfo
        let n = storyboard?.instantiateViewController(withIdentifier: "noti") as! Notifications
        
        items.append(ForwardItem(title: "Personal Info",controller: pi))
        items.append(ForwardItem(title: "Notifications",controller: n ))
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fCell", for: indexPath) as? ForwardCell else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item=items[indexPath.row]
        self.navigationController!.pushViewController(item.controller as! UIViewController, animated: true)
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
