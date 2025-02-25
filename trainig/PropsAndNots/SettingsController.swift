//
//  SettingsController.swift
//  trainig
//
//  Created by omer yildirim on 4.02.2025.
//

import UIKit

class SettingsController: UITableViewController {
    var data:[Any] = []
    var not:[SwitchItem] = []
    var coms:[SwitchItem] = []
    var personalInfo:[ForwardItem] = []
    var about:[ForwardItem] = []
    @IBOutlet weak var ni: UINavigationItem!
    var headers:[String] = []
    var forTrainer=false
    override func viewDidLoad() {
        super.viewDidLoad()
        addSwitch()
        addForward()
        data.append(not)
        if forTrainer{
            data.append(coms)
            headers = [String(localized:"notifications"),String(localized:"comments"),String(localized:"personal_info"),String(localized:"about_app")]
        }else{
            headers = [String(localized:"notifications"),String(localized:"personal_info"),String(localized:"about_app")]
        }
        data.append(personalInfo)
        data.append(about)
        tableView.sectionHeaderTopPadding=16
        self.title = "Settings"
       

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func addSwitch() {
        not.append(SwitchItem(title: "Allow/Reject Notifications",checked: true))
        coms.append(SwitchItem(title: "Allow/Reject Comments",checked: true))
    }
    func addForward() {
        
        let pi = storyboard?.instantiateViewController(withIdentifier: "upPerson") as! UpdatePersonalViewController
        let ab = storyboard?.instantiateViewController(withIdentifier: "abt") as! UpdateAboutViewController
        let ints = storyboard?.instantiateViewController(withIdentifier: "upInterests") as! UpdateInterestCollectionViewController
        let photo = storyboard?.instantiateViewController(withIdentifier: "upPhoto") as! UpdatePhotoViewController
        let video = storyboard?.instantiateViewController(withIdentifier: "upVideo") as! UpdateVideoViewController
        let cert = storyboard?.instantiateViewController(withIdentifier: "upCert") as! UpdateCertificateTableViewController
        if !forTrainer {
            personalInfo.append(ForwardItem(title: String(localized:"personal_info"),controller: pi))
        }
        personalInfo.append(ForwardItem(title: String(localized:"profile_photo"),controller: photo ))
        if forTrainer {
            personalInfo.append(ForwardItem(title: String(localized:"promotion_video"),controller: video ))
            personalInfo.append(ForwardItem(title: String(localized:"about"),controller: ab ))
            personalInfo.append(ForwardItem(title: String(localized:"specialities"),controller: ints ))
            personalInfo.append(ForwardItem(title: String(localized:"certificates"),controller: cert ))
        }else {
            personalInfo.append(ForwardItem(title: String(localized:"interests"),controller: ints ))
        }
        
    
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let c = self.data[section] as! [Any]
       return c.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = data[indexPath.section]
        
        switch cellModel {
        case  is [SwitchItem]:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as? SwitchCell else {
                return UITableViewCell()
            }
            let sItems=cellModel as! [SwitchItem]
            cell.configure(with: sItems[indexPath.row])
            return cell
        case is [ForwardItem]:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "fCell", for: indexPath) as? ForwardCell else {
                return UITableViewCell()
            }
            let fItems=cellModel as! [ForwardItem]
            cell.configure(with: fItems[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        var h: String=headers[section]
        h=h.lowercased()
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        header.textLabel?.text=h.capitalized
        header.textLabel?.textAlignment = NSTextAlignment.left
        header.backgroundView?.backgroundColor = .black
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = data[indexPath.section]
        
        switch cellModel {
        case  is [SwitchItem]: break
           
        case is [ForwardItem]:
            let fItems=cellModel as! [ForwardItem]
            let item = fItems[indexPath.row]
            let controller = item.controller as! UIViewController
            controller.title = item.title
            self.navigationController?.pushViewController(controller, animated: true)
        default: break
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "upPhoto"{
            let vc = segue.destination as UIViewController
                vc.navigationItem.title = "Update Photo"
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
