//
//  HealthKitManager.swift
//  HealthKitPractice
//
//  Created by Samantha Gatt on 8/20/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import HealthKit

enum HealthKitError: Error {
    case healthStoreNotAvailable
    case dataTypeNotAuthorized
    case authorizationError(error: Error)
    case noSamplesReturned
    case queryError(error: Error)
    
    init?(authorizationError: Error?) {
        if let error = authorizationError {
            self = .authorizationError(error: error)
        } else {
            return nil
        }
    }
    init?(queryError: Error?) {
        if let error = queryError {
            self = .queryError(error: error)
        } else {
            return nil
        }
    }
}

final class HealthKitManager {
    static let hkQuantTypeIdentifiersToRead: [HKQuantityTypeIdentifier] = [.bodyMass, .bloodPressureSystolic, .bloodPressureDiastolic, .heartRate, .stepCount]
    static var measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale.current
        formatter.unitStyle = .medium
        formatter.numberFormatter = NumberFormatter()
        formatter.numberFormatter.numberStyle = .decimal
        return formatter
    }()
    
    static func authorizeHealthKit(completion: @escaping (Bool, HealthKitError?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, .healthStoreNotAvailable)
            return
        }
        var readTypes: Set<HKObjectType> = []
        for identifier in hkQuantTypeIdentifiersToRead {
            if let hkObjectType = HKObjectType.quantityType(forIdentifier: identifier) {
                readTypes.insert(hkObjectType)
            } else {
                completion(false, .dataTypeNotAuthorized)
                return
            }
        }
        HKHealthStore().requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            let hkError = HealthKitError(authorizationError: error)
            completion(success, hkError)
        }
    }
    static func getSamples(for sampleType: HKSampleType, completion: @escaping ([HKQuantitySample]?, HealthKitError?) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: .distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: 20, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
                let hkError = HealthKitError(queryError: error)
                guard let samples = samples as? [HKQuantitySample] else {
                    completion(nil, hkError ?? .noSamplesReturned)
                    return
                }
                completion(samples, hkError)
            }
        }
        HKHealthStore().execute(query)
    }
}
