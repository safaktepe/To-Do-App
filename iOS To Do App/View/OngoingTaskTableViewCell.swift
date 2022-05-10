//
//  OngoingTaskTableViewCell.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 6.05.2022.
//

import UIKit


class OngoingTaskTableViewCell: UITableViewCell {
    
    var actionButtonDidTap: (() -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    func configure(with task: Task) {
        titleLabel.text = task.title
    }
    
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        actionButtonDidTap? ()
    }
}
