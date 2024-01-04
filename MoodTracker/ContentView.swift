//
//  ContentView.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 2.01.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Mood.timestamp, ascending: false)]) var moods: FetchedResults<Mood>

    @State private var selectedMoodIndex: Int?
    @State private var selectedActivities: Int?
    @State private var personName: String = ""
    @State var success = false
    
    let moodOptions = ["Good", "Bad", "Neutral","Angry"]
    let activities = ["Sports","Home","Work","Socializing","Other"]
    
    var body: some View {
        NavigationView {
            if success == false {
                VStack {
                    Text("How Do You Feel?")
                        .font(.system(.title))
                    HStack {
                        ForEach(0..<moodOptions.count) { index in
                            MoodButtonView(mood: moodOptions[index], isSelected: selectedMoodIndex == index) {
                                selectedMoodIndex = index
                            }
                        }
                    }
                    Spacer()
                    Text("What are you doing now?")
                    HStack {
                        ForEach(0..<activities.count) { index in
                            ActivityButtonView(activity: activities[index], isSelected: selectedActivities == index) {
                                selectedActivities = index
                            }
                            
                        }
                        .frame(width: 70,height: 50)
                    }
                    Spacer()
                    
                    Text("Who are you with right now?")
                    TextField("Enter your name", text: $personName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Spacer()
                    Button("Add") {
                        if let selectedMoodIndex = selectedMoodIndex, let selectedActivities = selectedActivities {
                            let chosenMood = moodOptions[selectedMoodIndex]
                            let chosenActivity = activities[selectedActivities]
                            
                            let newMood = Mood(context: moc)
                            newMood.id = UUID()
                            newMood.mood = chosenMood
                            newMood.timestamp = Date()
                            newMood.name = personName
                            newMood.activities = chosenActivity
                            /*  if !personName.isEmpty {
                             let person = Mood(context: moc)
                             person.name = personName
                             newMood.name = person
                             }*/
                            
                            
                            do {
                                try moc.save()
                            } catch {
                                print("Error saving mood: \(error)")
                            }
                        }
                        success = true
                    }
                    
                   
                }
                .padding()
                .navigationBarTitle("Mood Tracker")
            }else {
                ZStack{
                    Rectangle()
                        .foregroundStyle(Color.mint)
                        .ignoresSafeArea()
                    VStack(spacing: 10){
                        Spacer()
                            Text("Thank you for sharing your feelings with us!")
                          
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.black)
                            .font(.system(size: 25))
                            .padding()
                        
                            
                        
                        Text("The registration process was successful.")
                            .foregroundStyle(Color.gray)
                            .font(.system(size: 20))
                            .padding()
                            .multilineTextAlignment(.center)
                        Spacer()
                        NavigationLink(destination: MainView().navigationBarBackButtonHidden(true)) {
                            Text("OK")
                        }
                        Spacer()
                    }
                    .frame(width: 350, height: 400)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25,style: .continuous))
                }
            }
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MoodButtonView: View {
    let mood: String
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        VStack {
            Circle()
                .foregroundColor(isSelected ? Color.blue : Color.gray)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    onTap()
                }

            Text(mood)
        }
        .padding()
    }
}
struct ActivityButtonView: View {
    let activity: String
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        VStack {
            Circle()
                .foregroundColor(isSelected ? Color.blue : Color.gray)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    onTap()
                }

            Text(activity)
                .font(.system(size: 10))
        }
        .padding()
    }
}

/*
import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Mood.timestamp, ascending: false)]) var moods: FetchedResults<Mood>
    
    @State private var selectedMoodIndex = 0
    let moodOptions = ["Good", "Bad", "Neutral"]
    
    var body: some View {
        VStack {
            Picker("Select Mood", selection: $selectedMoodIndex) {
                ForEach(0..<moodOptions.count) { index in
                    Text(moodOptions[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            List(moods) { mood in
                Text("\(mood.mood ?? "Unknown") - \(formattedDate(mood.timestamp ?? Date()))")
            }
            
            Button("Add") {
                let chosenMood = moodOptions[selectedMoodIndex]
                
                let newMood = Mood(context: moc)
                newMood.id = UUID()
                newMood.mood = chosenMood
                newMood.timestamp = Date()
                
                do {
                    try moc.save()
                } catch {
                    print("Error saving mood: \(error)")
                }
            }
            Button("Clear All") {
                       clearAllMoods()
                   }
                   .foregroundColor(.red)
            
        }
        .padding()
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
}



#Preview {
    ContentView()
}
*/
