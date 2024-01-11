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
    @Environment(\.presentationMode) var presentationMode

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
                        ForEach(Array(0..<moodOptions.count), id: \.self) { index in
                            MoodButtonView(mood: moodOptions[index], isSelected: selectedMoodIndex == index) {
                                selectedMoodIndex = index
                            }
                        }
                    }
                    Spacer()
                    Text("What are you doing now?")
                    HStack {
                        ForEach(Array(0..<activities.count), id: \.self) { index in
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
                        NavigationLink(destination: MainView()) {
                            Text("OK")
                        }
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                    .frame(width: 350, height: 400)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25,style: .continuous))
                    //.navigationBarBackButtonHidden(false)
                }
            }
        }
        .navigationBarBackButtonHidden(success)
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

