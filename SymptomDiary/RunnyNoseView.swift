//
//  RunnyNoseView.swift
//  SymptomDiary
//
//  Created by Lukas Hirsch on 20.06.23.
//

import SwiftUI
import HealthKit


struct RunnyNoseView: View {
    let healthKitService: HealthKitService
    @State private var runnyNose: Int = 0
    
    var body: some View {
        VStack {
            Text("Runny Nose: \(runnyNose)")
                .font(.title)
                .padding()
            
            Button(action: {
                fetchRunnyNoseData()
            }) {
                Text("Fetch Runny Nose")
                    .padding()
            }
        }
    }
    
    func fetchRunnyNoseData() {
        healthKitService.fetchRunnyNoseData { runnyNoseValue, error in
            if let runnyNoseValue = runnyNoseValue {
                self.runnyNose = runnyNoseValue
            } else if let error = error {
                print("Error fetching runny nose data: \(error.localizedDescription)")
            }
        }
        
    }
}

struct RunnyNoseView_Previews: PreviewProvider {
    static var previews: some View {
        RunnyNoseView(healthKitService: HealthKitService())
    }
}
