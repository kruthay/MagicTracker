//
//  MagicTrackerApp.swift
//  MagicTracker
//
//  Created by Kruthay Donapati on 8/25/23.
//

import SwiftUI

@main
struct MagicTrackerApp: App {
    @StateObject var model = Model()
    var body: some Scene {
        WindowGroup {
            
            HomeView()
                .environmentObject(model)
        }
    }
}
