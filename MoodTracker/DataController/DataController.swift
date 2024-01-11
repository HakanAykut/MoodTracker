//
//  DataController.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 2.01.2024.
//

import CoreData
import Foundation

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "MoodTracker")
    
    init() {
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
        }
    }
}
