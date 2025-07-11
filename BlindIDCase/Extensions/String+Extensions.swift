//
//  String+Extensions.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation

extension String {
    // MARK: - Validity Checkers

    /// valid password should contain
    /// at least 8 characters
    /// at least 1 uppercase, 1 lowercase, 1 digit, and 1 special character
    /// example: Abcd123.
    func isValidPassword() -> Bool {
        let minLengthRule = count >= 8
        let upperCaseRule = range(of: "[A-Z]", options: .regularExpression) != nil
        let lowerCaseRule = range(of: "[a-z]", options: .regularExpression) != nil
        let digitRule = range(of: "\\d", options: .regularExpression) != nil
        let specialCharacterRule = range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil

        return minLengthRule && upperCaseRule && lowerCaseRule && digitRule && specialCharacterRule
    }

    /// valid email should contain
    /// at least one character + @ + at least one character + . + at least two characters
    /// example: "x.x@co"
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    /// valid name should contain
    /// at least 2 characters unless they are the same
    /// or at least 3 characters
    /// example: "su" or "ali"
    /// invalid example: "aa"
    func isValidName() -> Bool {
        return count >= 3 || (
            count == 2 &&
                first?.lowercased() != last?.lowercased()
        )
    }
}
