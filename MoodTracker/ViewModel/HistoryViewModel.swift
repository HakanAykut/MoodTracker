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

        for mood in moods {
            if let moodType = mood.mood {
                if mood.activities == activity {
                    moodCounts[moodType, default: 0] += 1
                    moodCount = moodCounts
                }
            }
        }

        prepareDataForPieChart(activity: activity)
        //print(prepareDataForPieChart(activity: activity))
        print("Mood Statistics for \(activity):")
        for (mood, count) in moodCounts {
            print("\(mood): \(count)")
            
        }
    }

    func printActivityStatistics(for mood: String) {
        var activityCounts: [String: Int] = [:]

        for moodEntry in moods {
            if let activity = moodEntry.activities, moodEntry.mood == mood {
                activityCounts[activity, default: 0] += 1
            }
        }
        prepareDataForActivityPieChart(mood: mood)
        //print("1----\(prepareDataForPieChart(activity: mood))")
        print("Activity Statistics for \(mood):")
        for (activity, count) in activityCounts {
            print("\(activity): \(count)")
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
        pieChartData = calculateMoodStatistics(for: activity)
            .map { (mood, count) in
                PieChartData(id: UUID(), title: mood, value: Double(count))
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
        
        pieChartData = calculateActivityStatistics(for: mood)
            .map { (activity, count) in
                PieChartData(id: UUID(), title: activity, value: Double(count))
            }
        print("A--\(pieChartData)")
        /*
        let activityStatistics = calculateActivityStatistics(for: mood)
        print("Activity Statistics for \(mood): \(activityStatistics)")

        pieChartData = activityStatistics.map { (activity, count) in
            PieChartData(id: UUID(), title: activity, value: Double(count))
        }

        print("Pie Chart Data for \(mood): \(pieChartData)")*/
    }

    struct CircleButtonView: View {
        let title: String
        let action: () -> Void

        var body: some View {
            VStack {
                Circle()
                    .foregroundColor(Color.blue)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(title)
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        action()
                    }
            }
        }
    }
}
