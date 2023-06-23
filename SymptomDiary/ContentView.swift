//
//  ContentView.swift
//  SymptomDiary
//
//  Created by Lukas Hirsch on 20.06.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let healthKitService = HealthKitService()
    
    var body: some View {
        VStack {
            Text("Symptom Diary")
                .font(.largeTitle)
                .fontWeight(.bold)
            .padding()
            RunnyNoseGraphView(healthKitService: healthKitService).padding()
            RunnyNoseView(healthKitService: healthKitService).padding()
        }.onAppear{
            healthKitService.requestPermissions()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
