//
//  Strings.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation

/// If necessary, Swiftlint should be used here

typealias LoginViewStrings = Strings.LoginStrings
typealias FavoritesTabStrings = Strings.FavoritesStrings

enum Strings {
    enum FavoritesStrings {
        case loginRequired
        case loginRequiredDescription
        case loginRequiredButtonText
        case noFavorites
        case noFavoritesDescription
        case discoverMovie

        var value: String {
            switch self {
            case .loginRequired:
                return "Giriş yapmanız gerekmektedir"
            case .loginRequiredDescription:
                return "Favori filmleri görüntülemek için lütfen giriş yapın"
            case .loginRequiredButtonText:
                return "Giriş Yap"
            case .noFavorites:
                return "Henüz hiç favori filmingiz yok"
            case .noFavoritesDescription:
                return "Favorilenmiş filmler burada görüntülenecektir"
            case .discoverMovie:
                return "Filmleri Keşfet"
            }
        }
    }

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

        // ProfileView
        case profile
        case logout
        case settings
        case updateProfile
        case error
        case tryAgain
        case loading

        // UserInfo
        case favorites
        case reviews
        case following

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
                return "Şifreniz en az 8 karakter olmalıdır. Bir büyük harf, bir küçük harf, bir sayı ve bir özel karakter içermelidir" // swiftlint:disable:this line_length
            case .passwordRenewal:
                return "Şifre yenileme e-postası"
            case .sentToEmail:
                return "adresinize gönderilmiştir."
            case .sendAgain:
                return "Tekrar Gönder"
            // ProfileView
            case .profile:
                return "Profil"
            case .logout:
                return "Çıkış Yap"
            case .settings:
                return "Ayarlar"
            case .updateProfile:
                return "Hesap Bilgilerini Güncelle"
            case .error:
                return "Hata!"
            case .tryAgain:
                return "Tekrar Dene"
            case .loading:
                return "Yükleniyor..."
            // UserInfo
            case .favorites:
                return "Favoriler"
            case .reviews:
                return "Yorumlar"
            case .following:
                return "Takip Edilen"
            }
        }
    }
}
