//
//  TaskTypeController.swift
//  todoManager
//
//  Created by van on 20.10.2023.
//

import UIKit

class TaskTypeController: UITableViewController, TaskCreatorProtocol {
    
    // MARK: closure to edit TASK TYPE
    var doAfterTypeSelected: ((TaskPriority) -> Void)?
    
    // 1. tuple describing task type
    typealias TypeCellDescription = (type: TaskPriority, title: String, description: String)
    
    // 2. collection of available type tasks with descriptions
    private var taskTypesInformation: [TypeCellDescription] = [
        (type: .important, title: "Important", description: "Main priority type of tasks. All main priority tasks shown at top of the task list "),
        (type: .normal, title: "Current", description: "Default priority task")]
    
    // 3. selected priority
    
    var selectedType: TaskPriority = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. get UINib object from xib file
        let cellTypeNib = UINib(nibName: "TaskTypeCell", bundle: nil)
        
        // 2. reguster custom cell in tableview
        
        tableView.register(cellTypeNib, forCellReuseIdentifier: "TaskTypeCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskTypesInformation.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTypeCell", for: indexPath) as! TaskTypeCell
        
        // get current element to show
        
        let typeDescription = taskTypesInformation[indexPath.row]
        
        // paste data in cell
        
        cell.typeTitle.text = typeDescription.title
        
        cell.typeDescription.text = typeDescription.description
        
        // if type is selected - mark
        
        if selectedType == typeDescription.type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get selectedType
        
        let selectedType = taskTypesInformation[indexPath.row].type
        
        //call handler
        
        doAfterTypeSelected?(selectedType)
        
        navigationController?.popViewController(animated: true)
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
