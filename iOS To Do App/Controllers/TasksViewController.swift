//
//  ViewController.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 4.05.2022.
//

import UIKit
import Loaf

class TasksViewController: UIViewController {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ongoingTasksContainerView: UIView!
    @IBOutlet weak var doneTasksContainerView: UIView!
    
    private let databaseManager = DatabaseManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
            }

   
    private func setupSegmentedControl() {
        menuSegmentedControl.removeAllSegments()
        
        MenuSection.allCases.enumerated().forEach { (index, section) in
            menuSegmentedControl.insertSegment(withTitle: section.rawValue, at: index, animated: false)
        }
         menuSegmentedControl.selectedSegmentIndex = 0
        showContainerView(for: .ongoing)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            showContainerView(for: .ongoing)
        case 1:
            showContainerView(for: .done)
        default: break
        }
    }
    
    private func showContainerView(for section: MenuSection) {
        switch section {
        case .ongoing:
            ongoingTasksContainerView.isHidden = false
            doneTasksContainerView.isHidden = true
        case .done:
            ongoingTasksContainerView.isHidden = true
            doneTasksContainerView.isHidden = false
        }
    }
    
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewTask",
           let destination = segue.destination as? NewTaskViewController {
            destination.delagate = self 
        }else if  segue.identifier == "showOngoingTask" {
            let destination = segue.destination as? OngoingTasksTableViewController
            destination?.delegate = self
        }
    }
    
   
    
    @IBAction func addTaskButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "showNewTask", sender: nil)
    }
    
    private func deleteTask(id : String){
        databaseManager.deleteTask(id: id) { [weak self] (result) in
            switch result {
            case .success:
                Loaf("Task deleted!", state: .info, location: .top, sender: self!).show()
            case.failure(let error):
                Loaf(error.localizedDescription, state: .info, location: .top, sender: self!).show()
            }
        }
    }
    
}


extension TasksViewController: OngoingTasksTVCDelegate {
        func showOptions(for task: Task) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let id = task.id else {  return }
            self.deleteTask(id: id)

        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension TasksViewController: TasksVCDelegate {
    func didAddTask(_ task: Task) {
        presentedViewController?.dismiss(animated: true, completion: { [unowned self] in
            self.databaseManager.addTask(task) { (result) in
                switch  result {
                case .success:
                    print("yaay")
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            }
        })
        
        
        
    }
}
