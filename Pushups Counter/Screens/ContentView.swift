//
//  ContentView.swift
//
//  Created by Richard Das (https://richarddas.com)
//

import SwiftUI
import Charts


struct ContentView: View {
    
    @State private var pushupsDetector = PushupsDetector()

    var body: some View {
        VStack(spacing: 40) {

            Text("\(pushupsDetector.count)")
                .font(.system(size: 96))
            
            Button(action: {
                if pushupsDetector.isActive {
                    pushupsDetector.endSession()
                } else {
                    pushupsDetector.startSession()
                }
            }) {
                Group {
                    if pushupsDetector.isActive {
                        Label("End Session", systemImage: "stop.circle.fill")
                            .foregroundStyle(.white)
                    } else {
                        Label("Start Session", systemImage: "play.circle.fill")
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(22)
            .background(.tint)
            .clipShape(.buttonBorder)
            
            if pushupsDetector.isActive && pushupsDetector.isValidPosition {
                Text("Good position!")
            } else {
                Text("Get into position!")
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
