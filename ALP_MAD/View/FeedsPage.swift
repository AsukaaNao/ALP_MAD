//
//  FeedsPage.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 30/05/24.
//  Copyright © 2024 test. All rights reserved.
//

import SwiftUI

struct FeedsPage: View {
    var user1 = UserTest(id: "1", name: "William", email: "william.miracle@gmail.com", password: "miracle123", birthday: Date(), profile_picture: Image("Image1"), coordinates: "", couple_id: "1")
    var user2 = UserTest(id: "2", name: "Giselle", email: "giselle.miracle@gmail.com", password: "miracle123", birthday: Date(), profile_picture: Image("Image1"), coordinates: "", couple_id: "1")
    
    var feed = Feed(id: "1", image: Image("Image1"), date: Date(), caption: "This is a simple caption", user_id: "1", feeds_id: "1")
    
    var body: some View {
        VStack {
            VStack (alignment: .leading, spacing: 12) {
                feed.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 264, height: 164)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.purple, lineWidth: 1)
                    )
                
                Text("4 minutes ago")
                    .font(.system(size: 8))
                    .padding(.leading, 8)
                
                HStack {
                    
                    Image("Image1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.purple, lineWidth: 1)
                        )
                    
                    VStack (alignment: .leading) {
                        Text("William 🤠")
                            .bold()
                            .font(.system(size: 14))

                        Text(feed.caption)
                            .font(.system(size: 12))
                    }
                    
                }
                .padding(.leading, 8)
            }
            .padding(12)
            .frame(width: 290)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.purple, lineWidth: 2)
            )
            .background(Color.clear)
            .cornerRadius(30)
            
        }
        .padding()
        
    }
}

#Preview {
    FeedsPage()
}
