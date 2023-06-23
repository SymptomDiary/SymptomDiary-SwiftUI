//
//  RunnyNoseView.swift
//  SymptomDiary
//
//  Created by Lukas Hirsch on 20.06.23.
//

import SwiftUI
import HealthKit


struct RunnyNoseView: View {
    @ObservedObject var healthKitService = HealthKitService()
    
    @State private var categoryValueSeverity: HKCategoryValueSeverity = HKCategoryValueSeverity.notPresent
    
    var body: some View {
        VStack {
            Button(action: {
                            addRunnyNoseData()
                        }) {
                            Text("Add Runny Nose Data")
                                .padding()
                        }
            RunnyNoseSeverityPicker(categoryValueSeverity: $categoryValueSeverity)
        }
    }
    
    func addRunnyNoseData() {
            let startDate = Date()
            let endDate = Date()
            
            healthKitService.addRunnyNoseData(severity: categoryValueSeverity, startDate: startDate, endDate: endDate) { success, error in
                if success {
                    print("Runny nose data added successfully.")
                    healthKitService.fetchRunnyNoseData()
                } else if let error = error {
                    print("Error adding runny nose data: \(error.localizedDescription)")
                } else {
                    print("Failed to add runny nose data.")
                }
            }
        }
    
}

struct RunnyNoseSeverityPicker: View {
    @Binding var categoryValueSeverity: HKCategoryValueSeverity
    
    var body: some View {
        Picker(selection: $categoryValueSeverity, label: Text("Picker")) {
            Text(HKCategoryValueSeverity.unspecified.stringRepresentation).tag(HKCategoryValueSeverity.unspecified)
            Text(HKCategoryValueSeverity.notPresent.stringRepresentation).tag(HKCategoryValueSeverity.notPresent)
            Text(HKCategoryValueSeverity.mild.stringRepresentation).tag(HKCategoryValueSeverity.mild)
            Text(HKCategoryValueSeverity.moderate.stringRepresentation).tag(HKCategoryValueSeverity.moderate)
            Text(HKCategoryValueSeverity.severe.stringRepresentation).tag(HKCategoryValueSeverity.severe)
        }
    }
}

struct RunnyNoseView_Previews: PreviewProvider {
    static var previews: some View {
        RunnyNoseView(healthKitService: HealthKitService())
    }
}
