//
//  DoneTasksTableViewController.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 4.05.2022.
//

import UIKit
import Loaf

class DoneTasksTableViewController: UITableViewController {
    
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let databaseManager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskListener()
   }
    
    private func addTaskListener() {
        databaseManager.addTaskListener(forDoneTask: true) { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func handleActionButton(for task: Task) {
        guard let id =  task.id else { return }
        databaseManager.updateTaskStatus(id: id, isDone: false) { [weak self] (result) in
            switch result {
            case .success:
                Loaf("Task is moved to Ongoing-Tasks!", state: .info, location: .top, sender: self!).show()
            case .failure(let error):
                Loaf(error.localizedDescription, state: .info, location: .top, sender: self!).show()
            }
        }
    }
}

extension DoneTasksTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DoneTaskTableViewCell
        let task = tasks[indexPath.item]
        cell.configure(with: task)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(for: task)
        }
        return cell
        
        
    }
    
}
