//
//  ConnectionProtocol.swift
//  todoManager
//
//  Created by van on 21.10.2023.
//

import Foundation


protocol TaskSetterProtocol : class {
    func setTasks(_ tasksCollection: [TaskProtocol])
}


protocol TaskCreatorProtocol : class {
    var selectedType: TaskPriority {get set}

    
    var doAfterTypeSelected: ((TaskPriority) -> Void)? {get set}

    
}

protocol TaskEditorProtocol: class {
    var taskText: String {get set}
    var taskType: TaskPriority {get set}
    var taskStatus: TaskStatus {get set}
    
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)? {get set}

}
