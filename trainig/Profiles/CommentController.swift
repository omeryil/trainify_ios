//
//  CommentController.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class CommentController: UITableViewController {

    var comments: [CommentItem] = []
    let functions=Functions()
    var userData:NSDictionary!
    var forTrainer=false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userData = CacheData.getUserData()!
        
    
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight=300
        self.tableView.rowHeight = UITableView.automaticDimension
        if forTrainer{
            addDataTrainer()
        }else {
            addData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
   
    func addData() {
        
        let id=userData["id"]
        let data:Any=[
            "uid":id
        ]
        functions.executeUserComment(data: data, onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                for item in resData{
                    let itemTop = item as! NSDictionary
                    let itemDic = itemTop["user_comments"] as! NSDictionary
                    let content = itemDic["content"] as! NSDictionary
                    let comitem = CommentItem(username:itemDic["trainer_name"] as? String ?? "" ,comment:content["comment"] as? String ?? "",rating:content["rating"] as? Float ?? 0,photo: itemDic["trainer_photo"] as? String ?? "")
                    self.comments.append(comitem)
                }
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }else{
                print(error!)
                
            }
        })
        
        
    }
    func addDataTrainer() {
        
        let id=userData["id"]
        let data:Any=[
            "tid":id
        ]
        functions.executeTrainerComment(data: data, onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                for item in resData{
                    let itemTop = item as! NSDictionary
                    let itemDic = itemTop["trainer_comments"] as! NSDictionary
                    let content = itemDic["content"] as! NSDictionary
                    let comitem = CommentItem(username:itemDic["user_name"] as? String ?? "" ,comment:content["comment"] as? String ?? "",rating:content["rating"] as? Float ?? 0,photo: itemDic["user_photo"] as? String ?? "")
                    self.comments.append(comitem)
                }
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }else{
                print(error!)
                
            }
        })
        
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comCell", for: indexPath) as! CommentCell
        let commentItem = comments[indexPath.row]
        cell.configure(with: commentItem)
        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
