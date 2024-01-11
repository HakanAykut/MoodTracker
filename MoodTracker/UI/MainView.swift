//
//  MainView.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 2.01.2024.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Mood.timestamp, ascending: false)]) var moods: FetchedResults<Mood>

    // Resim adlarını içeren dizi
    let moodImages = ["happy", "angry", "sad", "neutral"]
    
    @State private var currentIndex = 0
    
    var body: some View {
        NavigationView {
          
            VStack {
                Text("How Do You Feel?")
                    .padding()
                
                Image(moodImages[currentIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.animation(.easeInOut(duration: 1))
                    .transition(.opacity)
                    .frame(width: 150)
                    .onAppear {
                        // Otomatik geçiş için Timer kullanımı
                        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                            withAnimation {
                                currentIndex = (currentIndex + 1) % moodImages.count
                            }
                        }
                        
                        
                        timer.fire()
                    }
                    .padding()
                
                
                
                NavigationLink(destination: ContentView()) {
                    Text("Let's Start")
                }
                .padding()
                NavigationLink(destination: HistoryView(viewModel: HistoryViewModel(moods: moods)).preferredColorScheme(.dark)) {
                    Text("History")
                       // .preferredColorScheme(.dark)
                }
                .padding()
                
            }
           
            
        }
        .navigationBarBackButtonHidden(true)
        //.preferredColorScheme(.light)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
