//
//  TaskListController.swift
//  todoManager
//
//  Created by van on 18.10.2023.
//

import UIKit

class TaskListController: UITableViewController {
    
    // MARK: segue data transfer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateScreen" {
            let destination = segue.destination as! TaskEditController
            destination.doAfterEdit = {[unowned self] title, type, status in
                let newTask = Task(title: title, type: type, status: status)
                
                tasks[type]?.append(newTask)
            }
        }
    }
    
    var tasksStorage: TasksStorageProtocol = TasksStorage()
    
    var tasks: [TaskPriority: [TaskProtocol]] = [:] {
        didSet {
            // MARK: Apple MVC sort practice to weak connection to Model TaskStatus
            for (tasksGroupPriority, tasksGroup) in tasks {
                tasks[tasksGroupPriority] = tasksGroup.sorted {task1, task2 in
                    let task1position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
                    
                    let task2position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
                    
                    return task1position < task2position
                }
            }
        }
    }
    
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
    // MARK: Set task as completed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. check that task exists
        
        let taskType = sectionsTypesPosition[indexPath.section]
        
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        
        // 2. check that task has planned status
        guard tasks[taskType]![indexPath.row].status == .planned else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        // 3. Mark task as completed
        tasks[taskType]![indexPath.row].status = .completed
        
        // 4. Manually reload table section
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        
    }
    
    // MARK: Set task to "Planned"
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // получаем данные о задаче, по которой осуществлен свайп
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return nil }
        // действие для изменения статуса на "запланирована"
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Not completed") { _,_,_ in
            self.tasks[taskType]![indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        // действие для перехода к экрану редактирования
        let actionEditInstance = UIContextualAction(style: .normal, title: "Change") { _,_,_ in
            // загрузка сцены со storyboard
            let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TaskEditController111") as! TaskEditController
            // передача значений редактируемой задачи
            editScreen.taskText = self.tasks[taskType]![indexPath.row].title
            editScreen.taskType = self.tasks[taskType]![indexPath.row].type
            editScreen.taskStatus = self.tasks[taskType]![indexPath.row].status
            // передача обработчика для сохранения задачи
            editScreen.doAfterEdit = { [self] title, type, status in
                let editedTask = Task(title: title, type: type, status: status)
                tasks[taskType]![indexPath.row] = editedTask
                tableView.reloadData()
            }
            
            // переход к экрану редактирования
            self.navigationController?.pushViewController(editScreen, animated: true)
        }
        // изменяем цвет фона кнопки с действием
        actionEditInstance.backgroundColor = .darkGray
        // создаем объект, описывающий доступные действия
        // в зависимости от статуса задачи будет отображено 1 или 2 действия
        let actionsConfiguration: UISwipeActionsConfiguration
        if tasks[taskType]![indexPath.row].status == .completed {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actionSwipeInstance, actionEditInstance])
        } else {
            actionsConfiguration = UISwipeActionsConfiguration(actions:
                                                                [actionEditInstance]) }
        return actionsConfiguration }
    
    // MARK: Delete Task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // 1. select task type according to table section
        let taskType = sectionsTypesPosition[indexPath.section]
        
        // 2. remove task with selected "taskType" in table section
        tasks[taskType]?.remove(at: indexPath.row)
        
        // 3. remove task from table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    // MARK: Move rows
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // move from
        let taskTypeFrom = sectionsTypesPosition[sourceIndexPath.section]
        // move to
        let taskTypeTo = sectionsTypesPosition[destinationIndexPath.section]
        
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        
        // delete task from previous position
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        // paste task in new position
        tasks[taskTypeTo]!.insert(movedTask, at: destinationIndexPath.row)
        
        // if section change - change task type
        
        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        // update data
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    private func loadTasks(){
        sectionsTypesPosition.forEach {
            taskType in tasks[taskType] = []
        }
        
        tasksStorage.loadTasks().forEach {
            task in tasks[task.type]?.append(task)
        }
    }
    
    private func getConfiguredTaskCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskViewCell
        
        let taskType = sectionsTypesPosition[indexPath.section]
        
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        cell.title.text = currentTask.title
        
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        
        return cell
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let taskType = sectionsTypesPosition[section]
        
        guard let currentTaskType  = tasks[taskType] else {
            return 0
        }
        
        return currentTaskType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: two ways to configure Cell
        return getConfiguredTaskCell_stack(for: indexPath)
        //return getConfiguredTaskCell_constraints(for: indexPath)
    }
    
    private func getConfiguredTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraint", for: indexPath)
        
        let taskType = sectionsTypesPosition[indexPath.section]
        
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        
        textLabel?.text = currentTask.title
        
        if currentTask.status == .planned {
            textLabel?.textColor = .black
            symbolLabel?.textColor = .black
        } else {
            textLabel?.textColor = .lightGray
            textLabel?.textColor = .lightGray
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        
        let tasksType = sectionsTypesPosition[section]
        if tasksType == .important {
            title = "Important"
        } else if tasksType == .normal {
            title = "Current"
        }
        return title
    }
    
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .completed {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        
        return resultSymbol
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
