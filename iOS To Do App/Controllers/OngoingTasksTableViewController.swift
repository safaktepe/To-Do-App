//
//  OngoingTasksTableViewController.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 4.05.2022.
//

import UIKit
import Loaf

protocol OngoingTasksTVCDelegate: class{
     func showOptions(for task: Task)
}


class OngoingTasksTableViewController: UITableViewController {
    private let databaseManager = DatabaseManager()
    private var tasks: [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    weak var delegate: OngoingTasksTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskListener()

    }
    
    private func addTaskListener() {
        databaseManager.addTaskListener(forDoneTask: false) { [weak self] result in
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
        databaseManager.updateTaskStatus(id: id, isDone: true) { [weak self] (result) in
            switch result {
            case .success:
                Loaf("Task is done, congrats!", state: .info, location: .top, sender: self!).show()
            case .failure(let error):
                Loaf(error.localizedDescription, state: .info, location: .top, sender: self!).show()
            }
        }
    }
}


extension OngoingTasksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! OngoingTaskTableViewCell
    
        let task = tasks[indexPath.row]
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButton(for: task)
        }
        cell.configure(with: task)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.item]
        delegate?.showOptions(for: task )
    }
    
    
}

