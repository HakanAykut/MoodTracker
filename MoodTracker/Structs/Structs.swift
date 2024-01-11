//
//  Structs.swift
//  MoodTracker
//
//  Created by Hakan Aykut on 10.01.2024.
//

import SwiftUI



struct CircleButtonView: View {
    let title: String
    let action: () -> Void
    

    var body: some View {
        VStack {
            
            Circle()
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .overlay(
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                )
                .onTapGesture {
                    action()
                }
        }
    }
}

struct RectangleButtonView: View {
    let title: String
   
    let colorForTitle: [String: Color] = [
        "Angry" : .red,
        "Good" : .green,
        "Bad" : .orange,
        "Neutral" : .cyan,
        "Sports" : .red,
        "Home" : .green,
        "Work" : .orange,
        "Socializing" : .cyan,
        "Other" : .gray
        // Diğer aktivitelerin veya duygu durumlarının renkleri buraya eklenebilir
    ]

    var body: some View {
        VStack {
            HStack{
                Rectangle()
                    .foregroundColor(colorForTitle[title] ?? .blue)
                    .frame(width: 15, height: 15)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                    .lineLimit(1) // Metni bir satırda sınırla
                    .minimumScaleFactor(0.5) // Gerekirse metni küçült
            }
                
        }
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
