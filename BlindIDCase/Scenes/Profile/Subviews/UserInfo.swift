//
//  UserInfo.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import SwiftUI

struct UserInfo: View {
    let user: CurrentUser
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("\(user.name) \(user.surname)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 24) {
                VStack {
                    Text("\(user.likedMovies.count)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text(LoginViewStrings.favorites.value)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Divider()
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.5))
                
                VStack {
                    Text("0")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text(LoginViewStrings.reviews.value)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Divider()
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.5))
                
                VStack {
                    Text("0")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text(LoginViewStrings.following.value)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(Color.black.opacity(0.2))
            .cornerRadius(10)
        }
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(16)
    }
}
