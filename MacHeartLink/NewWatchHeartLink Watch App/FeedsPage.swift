//
//  FeedsPage.swift
//  WatchHeartLink Watch App
//
//  Created by MacBook Pro on 05/06/24.
//  Copyright © 2024 test. All rights reserved.
//

import SwiftUI

struct Feed: Identifiable {
    var id: String
    var image: String
    var date: Date
    var caption: String
    var user_name: String
    var user_picture: String
}

struct FeedsPage: View {
    
    var feeds: [Feed] = [
            Feed(id: "1", image: "Picnic", date: Date(), caption: "Picnic Date with Ning~", user_name: "Giselle 🐣💕", user_picture: "Giselle"),
            Feed(id: "2", image: "Coding", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, caption: "I'm Stressed :( text me", user_name: "Kevin 🤠", user_picture: "Kevin"),
            Feed(id: "3", image: "Sunset", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, caption: "Sunset as beautiful as you <3", user_name: "Kevin 🤠", user_picture: "Kevin"),
            Feed(id: "4", image: "Yemek", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, caption: "Want some?", user_name: "Giselle 🐣💕", user_picture: "Giselle"),
            Feed(id: "5", image: "Cat", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, caption: "Cat taking over your spot", user_name: "Kevin 🤠", user_picture: "Kevin"),
        ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if feeds.isEmpty {
                        Text("No feeds available. Create new ones to share with your partner!")
                            .font(.headline)
                            .padding()
                            .multilineTextAlignment(.center)
                        
                    } else {
                        ForEach(feeds) { feed in
                            FeedRow(feed: feed)
                        }
                    }
                }
            }
            .navigationTitle("Feeds")
        }
    }
}

struct FeedRow: View {
    var feed: Feed
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !feed.image.isEmpty {
                Image(feed.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple, lineWidth: 1)
                    )
            } else {
                Color.gray
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.purple, lineWidth: 1)
                    )
            }
            
            Text(feed.date, style: .relative)
                .font(.system(size: 10))
                .padding(.leading, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                if !feed.user_picture.isEmpty {
                    Image(feed.user_picture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.purple, lineWidth: 1)
                        )
                } else {
                    Color.gray
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.purple, lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading) {
                    Text(feed.user_name)
                        .bold()
                        .font(.system(size: 12))
                    
                    Text(feed.caption)
                        .font(.system(size: 10))
                }
                .padding(.leading, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(Color.clear)
        .cornerRadius(10)
    }
}

struct FeedsPage_Previews: PreviewProvider {
    static var previews: some View {
        FeedsPage()
    }
}

