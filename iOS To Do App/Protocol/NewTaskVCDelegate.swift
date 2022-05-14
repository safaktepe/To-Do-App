//
//  TasksVCDelegate.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 6.05.2022.
//

import Foundation

protocol NewTaskVCDelegate: class {
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
}


