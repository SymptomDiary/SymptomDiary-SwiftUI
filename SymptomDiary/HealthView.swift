//
//  HealthView.swift
//  SymptomDiary
//
//  Created by Lukas Hirsch on 20.06.23.
//

import SwiftUI
import HealthKit

struct HealthView: View {
    let healthKitService: HealthKitService
    @State private var heartRate: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Heart Rate: \(heartRate, specifier: "%.0f")")
                .font(.title)
                .padding()
            
            Button(action: {
                fetchHeartRateData()
            }) {
                Text("Fetch Heart Rate")
                    .padding()
            }
        }
    }
       
       func fetchHeartRateData() {
           healthKitService.fetchHeartRateData { heartRate, error in
               if let heartRate = heartRate {
                   self.heartRate = heartRate
               } else if let error = error {
                   print("Error fetching heart rate data: \(error.localizedDescription)")
               }
           }
       }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView(healthKitService: HealthKitService())
    }
}
