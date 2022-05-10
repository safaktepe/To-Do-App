//
//  DoneTaskTableViewCell.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 10.05.2022.
//

import UIKit

class DoneTaskTableViewCell: UITableViewCell {
    
    var actionButtonDidTap: (() -> Void)?

    @IBOutlet weak var titleLabel: UILabel!
    
    
    func  configure(with task: Task) {
        titleLabel.text = task.title
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        actionButtonDidTap?()
    }
    
}

