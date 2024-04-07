//
//  PhoneNumberTextField.swift
//  PhoneNumberKitTest
//
//  Created by Ivan Magda on 02/04/2024.
//

import SwiftUI
import UIKit
import PhoneNumberKit

struct PhoneNumberTextFieldView: UIViewRepresentable {
    @Binding var phoneNumber: String
    private let textField = PhoneNumberTextField()
    
    func makeUIView(context: Context) -> PhoneNumberTextField {
        textField.withExamplePlaceholder = true
        textField.withFlag = true
        textField.withPrefix = true
        textField.withDefaultPickerUI = true
        textField.becomeFirstResponder()
        return textField
    }
    
    func getCurentText() {
        self.phoneNumber = textField.text!
    }
    
    func setText(text: String) {
        textField.text = text
    }
    
    func updateUIView(_ uiView: PhoneNumberTextField, context: Context) {
    }
}
