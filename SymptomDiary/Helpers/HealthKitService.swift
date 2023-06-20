//
//  HealthKitService.swift
//  SymptomDiary
//
//  Created by Lukas Hirsch on 20.06.23.
//

import Foundation
import HealthKit

class HealthKitService{
    let healthStore = HKHealthStore()
    
    func requestPermissions() {
           let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
           let runnyNoseType = HKObjectType.categoryType(forIdentifier: .runnyNose)!
        
           let readTypes: Set<HKObjectType> = [heartRateType, runnyNoseType]
           
           healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
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
    
    func fetchHeartRateData(completion: @escaping (Double?, Error?) -> Void) {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let quantitySample = results?.first as? HKQuantitySample {
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let heartRate = quantitySample.quantity.doubleValue(for: heartRateUnit)
                completion(heartRate, nil)
            } else {
                completion(nil, nil) // Handle the case when no results are available
            }
        }
        
        healthStore.execute(query)
    }

    func fetchRunnyNoseData(completion: @escaping (Int?, Error?) -> Void) {
        let runnyNoseType = HKObjectType.categoryType(forIdentifier: .runnyNose)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: runnyNoseType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let categorySample = results?.first as? HKCategorySample {
                completion(categorySample.value, nil)
            } else {
                completion(nil, nil) // Handle the case when no results are available
            }
        }
        
        healthStore.execute(query)
    }
}
