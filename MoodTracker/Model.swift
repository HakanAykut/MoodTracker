//
//  Model.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 4.01.2024.
//

import Foundation

struct PieChartData: Identifiable {
    var id: UUID
    var title: String
    var value: Double
    var percent: String
    
}
