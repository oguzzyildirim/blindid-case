//
//  CustomTextField.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Combine
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var floatingText: String
    var isPassword: Bool = false
    var isDisabled: Bool = false
    var isEmail: Bool = false
    var isName: Bool = false

    @State private var errorText: String?
    @State private var isSecure: Bool = true
    @FocusState private var isFocused: Bool
    @State private var debounceTimer: Timer?

    private let nameUpperCharacterLimit = 45
    private let emailUpperCharacterLimit = 128

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 90)
                    .fill(Color.gray)

                RoundedRectangle(cornerRadius: 90)
                    .stroke(
                        isFocused ? Color.brown :
                            (errorText != nil ? Color.red :
                                (isPassword && !isSecure ? Color.red : Color.blue)),
                        lineWidth: 1
                    )

                HStack {
                    if isPassword && isSecure {
                        SecureField("", text: $text)
                            .focused($isFocused)
                            .padding(.horizontal, 20)
                            .padding(.top, isFocused || !text.isEmpty ? 8 : 0)
                            .padding(.bottom, isFocused || !text.isEmpty ? -8 : 0)
                            .font(.robotoBold(size: 14))
                            .onChange(of: text, perform: debounceTextChange)
                            .disabled(isDisabled)
                    } else {
                        TextField("", text: $text)
                            .keyboardType(isEmail ? .emailAddress : .default)
                            .textInputAutocapitalization(isEmail ? .never : .sentences)
                            .focused($isFocused)
                            .padding(.horizontal, 20)
                            .padding(.top, isFocused || !text.isEmpty ? 8 : 0)
                            .padding(.bottom, isFocused || !text.isEmpty ? -8 : 0)
                            .font(.robotoBold(size: 14))
                            .onChange(of: text, perform: debounceTextChange)
                            .onReceive(Just(text)) { _ in
                                limitText()
                            }
                            .disabled(isDisabled)
                    }

                    showPasswordButton
                        .isVisible(isPassword)
                }

                Text(isFocused || !text.isEmpty ? floatingText : placeholder)
                    .foregroundStyle(textColor())
                    .padding(.horizontal, 20)
                    .padding(.bottom, isFocused || !text.isEmpty ? 25 : 0)
                    .scaleEffect(isFocused || !text.isEmpty ? 0.8 : 1.0, anchor: .leading)
                    .animation(.easeInOut, value: isFocused || !text.isEmpty)
                    .font(isFocused || !text.isEmpty ? .robotoMedium(size: 14) : .robotoMedium(size: 14))
                    .onTapGesture {
                        isFocused = true
                    }
            }
            .padding(.horizontal, 10)
            .frame(height: 50)
            .opacity((isDisabled && !isPassword) ? 0.5 : 1)

            errorTitle
                .isVisible(errorText != nil)
        }
    }
}

private extension CustomTextField {
    var showPasswordButton: some View {
        Button {
            isSecure.toggle()
        } label: {
            Image(systemName: isSecure ? "eye.slash" : "eye")
                .foregroundColor(.white)
                .padding(.trailing)
        }
    }

    var errorTitle: some View {
        Text(errorText ?? "")
            .foregroundColor(.red)
            .font(.robotoBold(size: 12))
            .padding(.leading, 20)
    }
}

// MARK: - Helper Functions

private extension CustomTextField {
    func debounceTextChange(_ newValue: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            DispatchQueue.main.async {
                validate(newValue)
                if newValue.isEmpty {
                    isSecure = true
                    errorText = nil
                }
            }
        }
    }

    func limitText() {
        if isEmail, text.count > emailUpperCharacterLimit {
            text = String(text.prefix(emailUpperCharacterLimit))
        } else if isName, text.count > nameUpperCharacterLimit {
            text = String(text.prefix(nameUpperCharacterLimit))
        }
    }

    func validate(_ newText: String) {
        if isPassword {
            errorText = newText.isValidPassword() ? nil : LoginViewStrings.passwordRule.value
        } else if isEmail {
            errorText = newText.isValidEmail() ? nil : LoginViewStrings.emailRule.value
        } else if isName {
            errorText = newText.isValidName() ? nil : LoginViewStrings.nameRule.value
        }
    }

    func textColor() -> Color {
        if errorText != nil {
            return .red
        } else if isFocused || !text.isEmpty {
            return .orange
        }
        return .white
    }
}
