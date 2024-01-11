//
//  HistoryViewModel.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 4.01.2024.
//

import CoreData
import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var viewRecords = false
    @Published var selectedActivity: String?
    @Published var selectedPickerOption: String = "Mood"

    @Published var moods: FetchedResults<Mood>
    
    @Published var startActivity: String? = "Sports"
    @Published var startMood: String? = "Good"
    var filteredMoods: [Mood] {
        if let selectedActivity = selectedActivity, selectedActivity != "All" {
            return moods.filter { $0.activities == selectedActivity }
        } else {
            return Array(moods)
        }
    }
   
    @Published var moodCount: [String: Int] = [:]
    @Published var pieChartData: [PieChartData] = []

    init(moods: FetchedResults<Mood>) {
        self.moods = moods
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
        return dateFormatter.string(from: date)
    }

    func dataClear() {
    pieChartData = []
    }
    func clearAllMoods(moc: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Mood.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(batchDeleteRequest)
            try moc.save()
        } catch {
            print("Error clearing moods: \(error)")
        }

        moc.refreshAllObjects()
    }

    func printMoodStatistics(for activity: String) {
        var moodCounts: [String: Int] = [:]
        var totalMoods = 0

        for mood in moods {
            if let moodType = mood.mood, mood.activities == activity {
                moodCounts[moodType, default: 0] += 1
                totalMoods += 1
            }
        }

        prepareDataForPieChart(activity: activity)

        print("Mood Statistics for \(activity):")
        for (mood, count) in moodCounts {
            let percentage = calculatePercentage(count, total: totalMoods)
            print("\(mood): \(count) - \(percentage)%")
        }
    }
    func printActivityStatistics(for mood: String) {
        var activityCounts: [String: Int] = [:]
        var totalActivities = 0

        for moodEntry in moods {
            if let activity = moodEntry.activities, moodEntry.mood == mood {
                activityCounts[activity, default: 0] += 1
                totalActivities += 1
            }
        }

        prepareDataForActivityPieChart(mood: mood)

        print("Activity Statistics for \(mood):")
        for (activity, count) in activityCounts {
            let percentage = calculatePercentage(count, total: totalActivities)
            print("\(activity): \(count) - \(percentage)%")
        }
    }


    private func calculateMoodStatistics(for activity: String) -> [String: Int] {
        var moodCounts: [String: Int] = [:]

        for moodEntry in filteredMoods {
            if let moodType = moodEntry.mood, moodEntry.activities == activity {
                moodCounts[moodType, default: 0] += 1
            }
        }

        return moodCounts
    }

    private func prepareDataForPieChart(activity: String) {
        let moodCounts = calculateMoodStatistics(for: activity)
        let totalMoods = moodCounts.values.reduce(0, +)

        pieChartData = moodCounts.map { (mood, count) in
            let percentage = calculatePercentage(count, total: totalMoods)
            return PieChartData(id: UUID(), title: mood, value: Double(count), percent: percentage)
        }

        print("M--\(pieChartData)")
    }

    private func calculateActivityStatistics(for mood: String) -> [String: Int] {
        var activityCounts: [String: Int] = [:]

        for moodEntry in filteredMoods {
            if let activity = moodEntry.activities, moodEntry.mood == mood {
                activityCounts[activity, default: 0] += 1
            }
        }

        print("Activity Counts for \(mood): \(activityCounts)")
        return activityCounts
    }

    private func prepareDataForActivityPieChart(mood: String) {
        let activityCounts = calculateActivityStatistics(for: mood)
        let totalActivities = activityCounts.values.reduce(0, +)

        pieChartData = activityCounts.map { (activity, count) in
            let percentage = calculatePercentage(count, total: totalActivities)
            return PieChartData(id: UUID(), title: activity, value: Double(count), percent: percentage)
        }

        print("A--\(pieChartData)")
    }

    func calculatePercentage(_ count: Int, total: Int) -> String {
        let percentage = Double(count) / Double(total) * 100.0
        return String(format: "%.1f", percentage)
    }

    
    
}
