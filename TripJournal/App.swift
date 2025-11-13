import SwiftUI

@main
struct TripJournalApp: App {
    private let service = LiveJournalService()

    var body: some Scene {
        WindowGroup {
            RootView(service: service)
        }
    }
}
