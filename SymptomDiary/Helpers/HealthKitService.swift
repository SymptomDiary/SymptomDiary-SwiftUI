//
//  HealthKitService.swift
//  SymptomDiary
//
//  Created by Lukas Hirsch on 20.06.23.
//

import Foundation
import HealthKit

extension HKCategoryValueSeverity {
    var stringRepresentation: String {
        switch self {
        case .unspecified:
            return "Present"
        case .notPresent:
            return "Not Present"
        case .mild:
            return "Mild"
        case .moderate:
            return "Moderate"
        case .severe:
            return "Severe"
        }
    }
}

class HealthKitService: ObservableObject {
    let healthStore = HKHealthStore()
    
    let runnyNoseType = HKObjectType.categoryType(forIdentifier: .runnyNose)!
    
    @Published var runnyNoseData: [HKCategorySample] = []
    
    func requestPermissions() {
        let writeTypes: Set<HKSampleType> = [runnyNoseType]
        let readTypes: Set<HKObjectType> = [runnyNoseType]
        
        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { (success, error) in
            if success {
                // Permission granted
            } else {
                // Permission denied or error occurred
                if let error = error {
                    print("Error requesting authorization: \(error.localizedDescription)")
                } else {
                    print("Permission denied.")
                }
            }
        }
    }
    
    func fetchRunnyNoseData() {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: runnyNoseType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let error = error {
                print("Error fetching runny nose data: \(error.localizedDescription)")
                return
            }
            
            if let runnyNoseData = results as? [HKCategorySample] {
                DispatchQueue.main.async {
                    self.runnyNoseData = runnyNoseData
                }
            }
        }
        
        healthStore.execute(query)
    }
    
    func addRunnyNoseData(severity: HKCategoryValueSeverity, startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        let sample = HKCategorySample(type: runnyNoseType, value: severity.rawValue, start: startDate, end: endDate)
        
        healthStore.save(sample) { (success, error) in
            completion(success, error)
        }
    }
}
