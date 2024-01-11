//
//  HistoryView.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 2.01.2024.
//

import SwiftUI
import CoreData
import Charts

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Mood.timestamp, ascending: false)]) var moods: FetchedResults<Mood>
    
    @State var viewModel: HistoryViewModel
    @State private var selectedPickerOption: String = "Mood"

    @State var selectedMoodforPieChart: String = ""
    @State var selectedActivityforPieChart: String = ""
    
    var filteredMoods: [Mood] {
        if let selectedActivity = viewModel.selectedActivity, selectedActivity != "All" {
            return moods.filter { $0.activities == selectedActivity }
        } else {
            return Array(moods)
        }
    }
    
    let activities = ["All", "Sports", "Home", "Work", "Socializing", "Other"]
    let pickerOptions = ["Mood", "Activity"]
    
    let moodOptions = ["Good", "Bad", "Neutral","Angry"]
    let activityOptions = ["Sports", "Home", "Work", "Socializing", "Other"]
    let colorForMood : [String:Color] = [
        "Angry" : .red,
        "Good" : .green,
        "Bad" : .orange,
        "Neutral" : .cyan
    ]
    let colorForActivity : [String:Color] = [
        "Sports" : .red,
        "Home" : .green,
        "Work" : .orange,
        "Socializing" : .cyan,
        "Other" : .gray
    ]


    var body: some View {
        if viewModel.viewRecords == true {
            VStack {
                HStack {
                    ForEach(activities, id: \.self) { activity in
                        ActivityButtonView(activity: activity, isSelected: viewModel.selectedActivity == activity) {
                            viewModel.selectedActivity = activity
                        }
                        .frame(width: 70, height: 50)
                    }
                }
                
                List(filteredMoods) { mood in
                    Text("\(mood.mood ?? "Unknown") - \(viewModel.formattedDate(mood.timestamp ?? Date())) - \(mood.name ?? "unknown") - \(mood.activities ?? "unknown")")
                    
                }

                Button("OK") {
                    viewModel.viewRecords = false
                }
                
                Button("Clear All") {
                    viewModel.clearAllMoods(moc: moc)
                }
                .foregroundColor(.red)
            }
            .padding()
            .navigationBarTitle("History")
        } else {
            
                
            VStack {
                Picker("Select Option", selection:$selectedPickerOption) {
                    
                    ForEach(pickerOptions, id: \.self) { option in
                        Text(option)
                        
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedPickerOption == "Mood" {
                    // let _: () = viewModel.dataClear()
                    
                    ScrollView(.horizontal) {
                        
                        HStack {
                            ForEach(moodOptions, id: \.self) { mood in
                                CircleButtonView(title: mood) {
                                    // Burada mood seçme işlemleri yapılacak
                                    selectedMoodforPieChart = mood
                                    print("Selected Mood: \(mood)")
                                    viewModel.printActivityStatistics(for: mood)
                                    //viewModel.dataClear()
                                    
                                }
                                .padding()
                            }
                        }
                    }
                    HStack{
                        VStack {
                            Chart {
                                ForEach(viewModel.pieChartData) { data in
                                    let moodColor = colorForActivity[data.title] ?? .white
                                    
                                    SectorMark(angle: .value("Activity", data.value),
                                               innerRadius: .ratio(0.3),
                                               angularInset: 2.0)
                                    .foregroundStyle(moodColor)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay){
                                        Text("%\(data.percent)")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .chartBackground { ChartProxy in
                                Text(selectedMoodforPieChart)
                            }
                        }
                        VStack(alignment:.leading) {
                            ForEach(activityOptions, id: \.self) { activity in
                                RectangleButtonView(title: activity)
                                    .padding()
                            }
                        }
                    }
                    .onAppear {
                        // MARK: Picker'ın ilk açıldığında varsayılan aktiviteyi seçme
                        viewModel.printActivityStatistics(for: viewModel.startMood ?? "")
                        selectedMoodforPieChart = "Good"
                    }
                } else if selectedPickerOption == "Activity" {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(activityOptions, id: \.self) { activity in
                                
                                CircleButtonView(title: activity) {
                                    selectedActivityforPieChart = activity
                                    // Burada activity seçme işlemleri yapılacak
                                    print("Selected Activity: \(activity)")
                                    viewModel.printMoodStatistics(for: activity)
                                    
                                    
                                    
                                }
                                .padding()
                            }
                        }
                    }
                    HStack{
                        VStack {
                            Chart {
                                ForEach(viewModel.pieChartData) { data in
                                    let moodColor = colorForMood[data.title] ?? .white
                                    SectorMark(angle: .value("Activity", data.value) ,
                                               innerRadius: .ratio(0.3),
                                               angularInset: 2.0)
                                    .foregroundStyle(moodColor)
                                    .cornerRadius(5)
                                    .annotation(position: .overlay){
                                        Text("%\(data.percent)")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.white)
                                    }
                                    
                                    
                                }
                            }.chartBackground { ChartProxy in
                                Text(selectedActivityforPieChart)
                            }
                        }
                        VStack (alignment:.leading){
                            ForEach(moodOptions, id: \.self) { mood in
                                RectangleButtonView(title: mood)
                                    .padding()
                            }
                        }
                        
                    }
                    .onAppear {
                        // MARK: Picker'ın ilk açıldığında varsayılan aktiviteyi seçme
                        viewModel.printMoodStatistics(for: viewModel.startActivity ?? "")
                        selectedActivityforPieChart = "Sports"
                    }
                    
                }
                
                
                Spacer()
                Button("View Saved Records"){
                    viewModel.viewRecords = true
                }
            }
           // .preferredColorScheme(.dark)
            
            .padding()
        }
    }
       
    
 
    
    
  
}


