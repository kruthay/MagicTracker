//
//  HomeView.swift
//  MagicTracker
//
//  Created by Kruthay Donapati on 8/28/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            NavigationLink( "TrackPad ", destination: TrackpadView())
            NavigationLink( "Content ", destination: ContentView())
            NavigationLink("Gyro",destination: GyroView())
        }
    }
}

#Preview {
    HomeView()
}
