//
//  ContentView.swift
//  MagicTracker
//
//  Created by Kruthay Donapati on 8/25/23.
//

import SwiftUI
import Network
import CoreGraphics


struct ContentView: View {
    @State private var mousePosition: CGPoint = .zero
    @ObservedObject var model = Model()
        var body: some View {
            VStack {
                Text("Mouse X: \(Int(mousePosition.x)), Y: \(Int(mousePosition.y))")
                    .padding()
                Slider(value: $mousePosition.x, in: -UIScreen.main.bounds.width...UIScreen.main.bounds.width)
                    .padding(.horizontal)
                Slider(value: $mousePosition.y, in: -UIScreen.main.bounds.height...UIScreen.main.bounds.height)
                    .padding(.horizontal)
                Button("Start Browser") {
                    model.startStopBrowser()
                }
                Text(model.isBrowserStarted ? "Yes" : "No")
            }
            .onChange(of: mousePosition){ position in
                let data = "\(position.x),\(position.y)".data(using: .utf8)
                if let data = data {
                    if let client = model.client {
                        client.send(movements: [data])
                    }
                }
            }
        }


        
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
