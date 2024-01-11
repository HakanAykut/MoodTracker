//
//  MoodTrackerApp.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 2.01.2024.
//

import SwiftUI

@main
struct MoodTrackerApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
               
           
        }
    }
}
