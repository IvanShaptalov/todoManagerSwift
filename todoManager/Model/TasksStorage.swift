//
//  TasksStorage.swift
//  todoManager
//
//  Created by van on 18.10.2023.
//

import Foundation

protocol TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol]
    
    func saveTasks(_ tasks: [TaskProtocol])
    
}

class TasksStorage: TasksStorageProtocol {
    func loadTasks() -> [TaskProtocol] {
        // временная реализация, возвращающая тестовую коллекцию задач
        let testTasks: [TaskProtocol] = [
            Task(title: "Buy bread", type: .normal, status: .planned), Task(title: "Wash cat", type: .important, status: .planned), Task(title: "Pay for Arnold", type: .important, status:
                                                                                                                                            .completed),
            Task(title: "Buy new cleaner", type: .normal, status:
                    .completed),
            Task(title: "Buy new cleaner, and sell old via olx, to increace money reusable", type: .normal, status:
                    .completed),
            Task(title: "Gift flowers to wife", type: .important, status:
                    .planned)]
        
        return testTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        
    }
    
    
    
}
