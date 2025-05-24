//
//  Strings.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation

/// If necessary, Swiftlint should be used here

typealias LoginViewStrings = Strings.LoginStrings

enum Strings {
    enum LoginStrings {
        case header
        case subText
        case login
        case register
        case or
        case nonlogin
        case emptyRule
        
        case email
        case emailHolder
        case emailRule
        
        case password
        case passwordHolder
        case enterCurrentPassword
        case enterNewPassword
        case reenterNewPassword
        case forgetPassword
        case activationCode
        case activationButtonText
        case rememberMe
        case registerQuestion
        
        case name
        case nameHolder
        case surname
        case surnameHolder
        case nameRule
        
        case send
        case passwordRule
        case passwordRenewal
        case sentToEmail
        case sendAgain
        
        var value: String {
            switch self {
            case .header:
                return "BlindIDCase"
            case .subText:
                return "Movie-App"
            case .login:
                return "GİRİŞ YAP"
            case .register:
                return "ÜYE OL"
            case .or:
                return "veya"
            case .nonlogin:
                return "Üye Olmadan Devam Et"
            case .emptyRule:
                return "Boş Bırakılamaz"
            case .email:
                return "E-Posta"
            case .emailHolder:
                return "E-Posta"
            case .emailRule:
                return "Lütfen Geçerli E-Posta Giriniz."
            case .password:
                return "Şifre"
            case .passwordHolder:
                return "Şifre"
            case .enterCurrentPassword:
                return "Mevcut Şifreni Gir"
            case .enterNewPassword:
                return "Yeni Şifreni Gir"
            case .reenterNewPassword:
                return "Yeni Şifreni Tekrar Gir"
            case .forgetPassword:
                return "Şifremi Unuttum"
            case .activationCode:
                return "Üyelik Aktivasyon Maili"
            case .activationButtonText:
                return "Üyelik aktivasyon e-maili gelmedi"
            case .rememberMe:
                return "Beni Hatırla"
            case .registerQuestion:
                return "Hesabınız Yok Mu?"
            case .name:
                return "Ad"
            case .nameHolder:
                return "Ad"
            case .surname:
                return "Soyad"
            case .surnameHolder:
                return "Soyad"
            case .nameRule:
                return "Hatalı Giriş"
            case .send:
                return "Gönder"
            case .passwordRule:
                return "Şifreniz en az 8 karakter olmalıdır. Bir büyük harf, bir küçük harf, bir sayı ve bir özel karakter içermelidir"
            case .passwordRenewal:
                return "Şifre yenileme e-postası"
            case .sentToEmail:
                return "adresinize gönderilmiştir."
            case .sendAgain:
                return "Tekrar Gönder"
            }
        }
    }
}
