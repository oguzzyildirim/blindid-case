//
//  ProfileUpdateForm.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 26.05.2025.
//

import SwiftUI

struct ProfileUpdateForm: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var password: String

    var body: some View {
        VStack(spacing: 16) {
            CustomTextField(
                text: $firstName,
                placeholder: LoginViewStrings.nameHolder.value,
                floatingText: LoginViewStrings.name.value,
                isName: true
            )

            CustomTextField(
                text: $lastName,
                placeholder: LoginViewStrings.surnameHolder.value,
                floatingText: LoginViewStrings.surname.value,
                isName: true
            )

            CustomTextField(
                text: $email,
                placeholder: LoginViewStrings.emailHolder.value,
                floatingText: LoginViewStrings.email.value,
                isEmail: true
            )

            CustomTextField(
                text: $password,
                placeholder: LoginViewStrings.passwordHolder.value,
                floatingText: LoginViewStrings.password.value,
                isPassword: true
            )
        }
    }
}
