import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .mainPage
    
    enum Tab {
        case mainPage, feeds, events
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationContainer {
                NavigationStack {
                    RootView()  // MainPage()
                }
            }
            .tabItem {
                Label("Main Page", systemImage: "house")
            }
            .tag(Tab.mainPage)
            
            NavigationContainer {
                FeedsPage()
            }
            .tabItem {
                Label("Feeds", systemImage: "newspaper")
            }
            .tag(Tab.feeds)
            
            NavigationContainer {
                EventsCalendarViewMac()
            }
            .tabItem {
                Label("Events", systemImage: "calendar")
            }
            .tag(Tab.events)
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

struct NavigationContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        //                        Button("Back") {
                        //                            // Handle back button action
                        //                        }
                    }
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(EventStore(preview: true))
    }
}
