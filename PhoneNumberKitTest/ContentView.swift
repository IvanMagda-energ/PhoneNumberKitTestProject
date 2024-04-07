//
//  ContentView.swift
//  PhoneNumberKitTest
//
//  Created by Ivan Magda on 25.03.2024.
//

import SwiftUI
import PhoneNumberKit

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State var phoneNumber: String = ""
    @State var phoneField: PhoneNumberTextFieldView?
    
    var body: some View {
        VStack {
            VStack {
                self.phoneField
                    .frame(minWidth: 0, maxWidth: .infinity,minHeight: 0, maxHeight: 60)
                    .keyboardType(.numberPad)
                    .border(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button {
                    self.phoneField?.getCurentText()
                    viewModel.testParsePhoneNumber(phoneNumber)
                } label: {
                    Text("Check Number")
                }
                .buttonStyle(.bordered)
                
                Text(viewModel.phoneNumber)
                Text(viewModel.countryCode)
                Text(viewModel.regionID)
            }
            .onAppear {
                self.phoneField = PhoneNumberTextFieldView(phoneNumber: $phoneNumber)
                self.phoneField?.setText(text: "123456789")
            }
            .padding()
            
            Divider()
            
            VStack{
                Text("Tested phone number count: \(viewModel.phoneNumberArray.count)")
                    .font(.headline)
                    .padding()
                
                Text("First test, parsed contact count: \(viewModel.parsedPhoneNumberArrayOne.count)")
                
                Text("First test time execution: \(viewModel.executionTimeForOneTestFunction)")
                
                Button {
                    viewModel.testMultiplyParseOne()
                } label: {
                    Text("First test")
                }
                .buttonStyle(.bordered)
                .padding(.bottom)

                Text("Second test, parsed contact count: \(viewModel.parsedPhoneNumberArrayTwo.count)")
                
                Text("Second test time execution: \(viewModel.executionTimeForTwoTestFunction)")
                
                Button {
                    viewModel.testMultiplyParseTwo()
                } label: {
                    Text("Second test")
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
            .padding()
        }
        .onAppear {
            viewModel.createLargePhoneNumberArray()
        }
    }
}

#Preview {
    ContentView()
}
