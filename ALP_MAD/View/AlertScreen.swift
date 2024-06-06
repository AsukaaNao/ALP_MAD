//
//  AlertScreen.swift
//  ALP_MAD
//
//  Created by student on 31/05/24.
//  Copyright © 2024 test. All rights reserved.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct AlertScreen: View {
    var body: some View {
        NavigationView{
            VStack(spacing: 40) {
                Spacer()
                
                Text("Allow tracking and accessing your storage on the app for:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(Color(hex:"#FE748E"))
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color(hex:"#FE748E"))
                            .font(.system(size: 40))
                        Spacer().frame(width: 10)  // Add a spacer with fixed width
                        Text("Your location for your partner to see.")
                            .foregroundColor(Color(hex:"#FE748E"))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        Spacer()  // Fill remaining space
                    }
                    
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(Color(hex:"#FE748E"))
                            .font(.system(size: 40))
                        Spacer().frame(width: 10)  // Add a spacer with fixed width
                        Text("Upload your photo for your partner to see")
                            .foregroundColor(Color(hex:"#FE748E"))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        Spacer()  // Fill remaining space
                    }
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(hex:"#FE748E"))
                            .font(.system(size: 40))
                        Spacer().frame(width: 10)  // Add a spacer with fixed width
                        Text("Personal chat with your partner.")
                            .foregroundColor(Color(hex:"#FE748E"))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                        Spacer()  // Fill remaining space
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                NavigationLink(destination: MainPage(showSignInView: .constant(true))) {
                    Text("Confirm")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#37B7D1"))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
            }
            .padding()
            
        }

    }
    
}

#Preview {
    AlertScreen()
}
