//
//  WidgetHeartLink.swift
//  WidgetHeartLink
//
//  Created by MacBook Pro on 04/06/24.
//  Copyright © 2024 test. All rights reserved.
//

import WidgetKit
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import Firebase

struct WidgetHeartLinkEntryView: View {
    var entry: Feed
    
    var body: some View {
        ZStack {
            if !entry.image.isEmpty, let url = URL(string: entry.image) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else if phase.error != nil {
                        Color.gray
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Color.purple
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            } else {
                Color.blue
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text(entry.caption)
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct Feed: Identifiable, TimelineEntry {
    var id: String
    var image: String
    var date: Date
    var caption: String
    var user_name: String
    var user_picture: String
}

struct Provider: TimelineProvider {
    
    init() {
        FirebaseApp.configure()
    }
    
    func placeholder(in context: Context) -> Feed {
        return Feed(id: "", image: "", date: Date(), caption: "Latest feed caption", user_name: "", user_picture: "")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Feed) -> ()) {
        let placeholderFeed = Feed(id: "", image: "", date: Date(), caption: "Latest feed caption", user_name: "", user_picture: "")
        completion(placeholderFeed)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Feed>) -> ()) {
        fetchLatestFeed { feed in
            let timeline = Timeline(entries: [feed], policy: .atEnd)
            completion(timeline)
        }
    }
    
    private func fetchLatestFeed(completion: @escaping (Feed) -> ()) {
        let db = Firestore.firestore()
        let uid = "fer63Q4T9aCtdpXwkxe5"
        
        db.collection("couples").document(uid).collection("feeds")
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching latest feed: \(error)")
                    let feed = Feed(id: "", image: "", date: Date(), caption: "Error fetching feed", user_name: "", user_picture: "")
                    completion(feed)
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    let feed = Feed(id: "", image: "", date: Date(), caption: "No feeds available", user_name: "", user_picture: "")
                    completion(feed)
                    return
                }
                
                let data = document.data()
                let id = document.documentID
                let imagePath = data["image"] as? String ?? ""
                let caption = data["caption"] as? String ?? ""
                let timestamp = data["date"] as? Timestamp
                let date = timestamp?.dateValue() ?? Date()
                let user_name = data["user_name"] as? String ?? ""
                let user_picture = data["user_picture"] as? String ?? ""
                
                var feed = Feed(id: id, image: "", date: date, caption: caption, user_name: user_name, user_picture: user_picture)
                
                loadImage(imagePath: imagePath) { imageURL in
                                    feed.image = imageURL
                                    completion(feed)
                                }
            }
    }
    
    private func loadImage(imagePath: String, completion: @escaping (String) -> ()) {
            let storageRef = Storage.storage().reference().child(imagePath)
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching image URL: \(error)")
                    completion("")
                } else if let url = url {
                    completion(url.absoluteString)
                } else {
                    completion("")
                }
            }
        }
}

struct WidgetHeartLink: Widget {
    let kind: String = "WidgetHeartLink"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetHeartLinkEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetHeartLinkEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Latest Feed Widget")
        .description("Shows the latest feed's image and caption.")
    }
}



