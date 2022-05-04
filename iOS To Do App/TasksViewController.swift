//
//  ViewController.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 4.05.2022.
//

import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ongoingTasksContainerView: UIView!
    @IBOutlet weak var doneTasksContainerView: UIView!
    
    
    
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
    
    
    @IBAction func addTaskButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "showAddNewTask", sender: nil)
    }
    
}

