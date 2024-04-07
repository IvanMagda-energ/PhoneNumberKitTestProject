//
//  ContentViewModel.swift
//  PhoneNumberKitTest
//
//  Created by Ivan Magda on 25.03.2024.
//

import SwiftUI
import PhoneNumberKit

final class ContentViewModel: ObservableObject {
    let phoneNumberKit = PhoneNumberKit()
    @Published var phoneNumber: String = ""
    @Published var countryCode: String = ""
    @Published var regionID: String = ""
    @Published var executionTimeForOneTestFunction: Double = 0.0
    @Published var executionTimeForTwoTestFunction: Double = 0.0
    @Published var phoneNumberArrayCount: Int = 0
    
    var phoneNumberArray: [String] = []
    var parsedPhoneNumberArrayOne: [PhoneNumber] = []
    var parsedPhoneNumberArrayTwo: [PhoneNumber] = []
    
    func testParsePhoneNumber(_ phoneNumber: String) {
        do {
            let parsedPhoneNumber = try phoneNumberKit.parse(phoneNumber)
            
            self.phoneNumber = phoneNumberKit.format(parsedPhoneNumber, toType: .e164)
            self.countryCode = parsedPhoneNumber.countryCode.description
            self.regionID = parsedPhoneNumber.regionID ?? ""
        } catch {
            self.phoneNumber = error.localizedDescription
            self.countryCode = ""
            self.regionID = ""
        }
    }
    
    func createLargePhoneNumberArray() {
        for _ in 0..<1000 {
            self.phoneNumberArray.append(contentsOf: Constants.phoneNumberArray)
        }
        phoneNumberArrayCount = phoneNumberArray.count
    }
    
    func testMultiplyParseOne() {
        let startTime = Date.now
        for phone in phoneNumberArray {
            if let parsedPhone = try? phoneNumberKit.parse(phone) {
                parsedPhoneNumberArrayOne.append(parsedPhone)
            }
        }
        let endTime = Date.now
        executionTimeForOneTestFunction = endTime.timeIntervalSince(startTime)
    }
    
    func testMultiplyParseTwo() {
        let startTime = Date.now
        
        var hasError = false

        var multiParseArray = [PhoneNumber](unsafeUninitializedCapacity: phoneNumberArray.count) { buffer, initializedCount in
            DispatchQueue.concurrentPerform(iterations: phoneNumberArray.count) { index in
                let numberString = phoneNumberArray[index]
                do {
                    let phoneNumber = try phoneNumberKit.parse(numberString, withRegion: "UA", ignoreType: false)
                    buffer.baseAddress!.advanced(by: index).initialize(to: phoneNumber)
                } catch {
                    buffer.baseAddress!.advanced(by: index).initialize(to: PhoneNumber.notPhoneNumber())
                    hasError = true
                }
            }
            initializedCount = phoneNumberArray.count
        }

        if hasError {
            multiParseArray = multiParseArray.filter { $0.type != .notParsed }
        }
        parsedPhoneNumberArrayTwo.append(contentsOf: multiParseArray)
        
        let endTime = Date.now
        executionTimeForTwoTestFunction = endTime.timeIntervalSince(startTime)
    }
}
