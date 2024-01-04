//
//  HistoryView.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 2.01.2024.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Mood.timestamp, ascending: false)]) var moods: FetchedResults<Mood>

    @State private var viewRecords = false
    @State private var selectedActivity: String?
    @State private var selectedPickerOption: String = "Mood"
    
    var filteredMoods: [Mood] {
        if let selectedActivity = selectedActivity, selectedActivity != "All" {
            return moods.filter { $0.activities == selectedActivity }
        } else {
            return Array(moods)
        }
    }
    
    let activities = ["All", "Sports", "Home", "Work", "Socializing", "Other"]
    let pickerOptions = ["Mood", "Activity"]
    
    let moodOptions = ["Good", "Bad", "Neutral","Angry"]
    let activityOptions = ["Sports", "Home", "Work", "Socializing", "Other"]


    var body: some View {
        if viewRecords == true {
            VStack {
                HStack {
                    ForEach(activities, id: \.self) { activity in
                        ActivityButtonView(activity: activity, isSelected: selectedActivity == activity) {
                            selectedActivity = activity
                        }
                        .frame(width: 70, height: 50)
                    }
                }
                
                List(filteredMoods) { mood in
                    Text("\(mood.mood ?? "Unknown") - \(formattedDate(mood.timestamp ?? Date())) - \(mood.name ?? "unknown") - \(mood.activities ?? "unknown")")
                }

                Button("OK") {
                    viewRecords = false
                }
                
                Button("Clear All") {
                    clearAllMoods()
                }
                .foregroundColor(.red)
            }
            .padding()
            .navigationBarTitle("History")
        } else {
            VStack {
                Picker("Select Option", selection: $selectedPickerOption) {
                    ForEach(pickerOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedPickerOption == "Mood" {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(moodOptions, id: \.self) { mood in
                                CircleButtonView(title: mood) {
                                    // Burada mood seçme işlemleri yapılacak
                                    print("Selected Mood: \(mood)")
                                    printActivityStatistics(for: mood)
                                }
                                .padding()
                            }
                        }
                    }
                } else if selectedPickerOption == "Activity" {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(activityOptions, id: \.self) { activity in
                                CircleButtonView(title: activity) {
                                    // Burada activity seçme işlemleri yapılacak
                                    print("Selected Activity: \(activity)")
                                    printMoodStatistics(for: activity)
                                }
                                .padding()
                            }
                        }
                    }
                }
                

                Spacer()
                Button("View Saved Records"){
                    viewRecords = true
                }
            }
            .padding()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
        return dateFormatter.string(from: date)
    }

    private func clearAllMoods() {
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
    
    private func printMoodStatistics(for activity: String) {
           var moodCounts: [String: Int] = [:]

           for mood in filteredMoods {
               if let moodType = mood.mood {
                   if mood.activities == activity {
                       moodCounts[moodType, default: 0] += 1
                   }
               }
           }

           print("Mood Statistics for \(activity):")
           for (mood, count) in moodCounts {
               print("\(mood): \(count)")
           }
       }
    
    private func printActivityStatistics(for mood: String) {
        var activityCounts: [String: Int] = [:]

        for moodEntry in filteredMoods {
            if let activity = moodEntry.activities, moodEntry.mood == mood {
                activityCounts[activity, default: 0] += 1
            }
        }

        print("Activity Statistics for \(mood):")
        for (activity, count) in activityCounts {
            print("\(activity): \(count)")
        }
    }


  
}
