//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by diayan siat on 11/07/2021.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    //source of truth for app’s data by adding a @State property
    @State private var scrums = DailyScrum.data
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                //pass a binding to that data down the hierarchy to ScrumsList
                ScrumsView(scrums: $scrums)
            }
        }
    }
}
