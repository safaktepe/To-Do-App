//
//  DatabaseManager.swift
//  iOS To Do App
//
//  Created by Mert Şafaktepe on 6.05.2022.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

class DatabaseManager {
    private let db = Firestore.firestore()
    private lazy var tasksCollection = db.collection("tasks")
    func addTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        do{
            try tasksCollection.addDocument(from: task, completion: { (error) in
                if let error = error {
                    completion(.failure(error))
                }else{
                    completion(.success(()))
                }
            })
            
        } catch(let error){
            completion(.failure(error))
   }
    }
}

