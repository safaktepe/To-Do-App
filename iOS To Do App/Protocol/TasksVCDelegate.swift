//
//  TasksVCDelegate.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 6.05.2022.
//

import Foundation

protocol TasksVCDelegate: class {
    func didAddTask(_ task: Task)
}
