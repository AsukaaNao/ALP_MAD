////
////  FeedsPage.swift
////  WatchHeartLink Watch App
////
////  Created by MacBook Pro on 05/06/24.
////  Copyright © 2024 test. All rights reserved.
////
//
//import SwiftUI
//
//struct FeedsPage: View {
//    @StateObject private var feedVM = FeedVM()
//    @State private var isPresentingCreateFeedPage = false
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 20) {
//                if feedVM.feeds.isEmpty {
//                    Text("No feeds available. Create new ones to share with your partner!")
//                        .font(.headline)
//                        .padding()
//                        .multilineTextAlignment(.center)
//                    
//                } else {
//                    ForEach(feedVM.feeds) { feed in
//                        FeedRow(feed: feed)
//                    }
//                }
//            }
//            .onAppear {
//                feedVM.fetchFeeds()
//            }
//        }
//    }
//}
//
//struct FeedRow: View {
//    var feed: Feed
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            if !feed.image.isEmpty, let url = URL(string: feed.image) {
//                AsyncImage(url: url) { phase in
//                    if let image = phase.image {
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: 100)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.purple, lineWidth: 1)
//                            )
//                    } else if phase.error != nil {
//                        Color.gray
//                            .frame(height: 100)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.purple, lineWidth: 1)
//                            )
//                    } else {
//                        Color.gray
//                            .frame(height: 100)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.purple, lineWidth: 1)
//                            )
//                    }
//                }
//            }
//            
//            Text(feed.date, style: .relative)
//                .font(.system(size: 10))
//                .padding(.leading, 4)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            HStack {
//                if !feed.user_picture.isEmpty, let url = URL(string: feed.user_picture) {
//                    AsyncImage(url: url) { phase in
//                        if let image = phase.image {
//                            image
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 30, height: 30)
//                                .clipShape(Circle())
//                                .overlay(
//                                    Circle()
//                                        .stroke(Color.purple, lineWidth: 1)
//                                )
//                        } else if phase.error != nil {
//                            Color.gray
//                                .frame(width: 30, height: 30)
//                                .clipShape(Circle())
//                                .overlay(
//                                    Circle()
//                                        .stroke(Color.purple, lineWidth: 1)
//                                )
//                        } else {
//                            Color.gray
//                                .frame(width: 30, height: 30)
//                                .clipShape(Circle())
//                                .overlay(
//                                    Circle()
//                                        .stroke(Color.purple, lineWidth: 1)
//                                )
//                        }
//                    }
//                } else {
//                    Color.gray
//                        .frame(width: 30, height: 30)
//                        .clipShape(Circle())
//                        .overlay(
//                            Circle()
//                                .stroke(Color.purple, lineWidth: 1)
//                        )
//                }
//                
//                VStack(alignment: .leading) {
//                    Text(feed.user_name)
//                        .bold()
//                        .font(.system(size: 12))
//                    
//                    Text(feed.caption)
//                        .font(.system(size: 10))
//                }
//                .padding(.leading, 4)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .padding(8)
//        .background(Color.clear)
//        .cornerRadius(10)
//    }
//}
//
//struct FeedsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedsPage()
//    }
//}
//
