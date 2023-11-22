//
//  HomeView.swift
//  MagicTracker
//
//  Created by Kruthay Donapati on 8/28/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model : Model
    var body: some View {
        NavigationStack {
            
            VStack {
                ForEach(model.devicesFound.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    Button(key) {
                        model.connect(to: key)
                    }
                }
            }
            List {
                NavigationLink( destination:TrackpadView()){
                    Text("Mouse")
                }
            }

            .toolbar {
                if !model.isBrowserStarted {
                    Button("Start Browser") {
                        model.startBrowser()
                    }
                } else {
                    Button("Stop Browser") {
                        model.stopBrowser()
                    }
                }
                if let client = model.client {
                    Button ("Stop Connection") {
                        withAnimation {
                            model.stopConnection()
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    HomeView()
}
