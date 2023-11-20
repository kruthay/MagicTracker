//
//  TrackpadView.swift
//  MagicTracker
//
//  Created by Kruthay Donapati on 8/28/23.
//

import SwiftUI

struct TrackpadView: View {
    
    @State var points: [CGPoint] = []
    @State private var mousePosition: CGPoint = .zero
    @EnvironmentObject var model : Model
    @State private var startPoint: CGPoint = .zero
    
    var body: some View {
        
        
        ZStack {
            GeometryReader { proxy in
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .overlay (
                        TwoFingerTapView { gesture in
                            print(gesture)
                            print("Two Taps Detected")
                            if let client = model.client {
                                client.sendTapMovement(message: "rightClicked")
                            }
                        }
                    )
                    .gesture(
                        
                        DragGesture()
                            .onChanged { value in
                                self.addNewPoint(value)
                                
                                if let data = transformPoints(dragValue : value, environmentSize : proxy.size) {
                                    if let client = model.client {
                                        client.send(movement: data)
                                    }
                                }
                                else {
                                    print("Not Working")
                                }
                            }
                            .onEnded { value in
                                self.points = []
                                if let client = model.client {
                                    client.sendLastMovement()
                                }
                            }
                            .exclusively(
                                before: TapGesture(count: 2).onEnded {
                                    print("clicked")
                                    if let client = model.client {
                                        client.sendTapMovement(message: "clicked")
                                    }
                                }.exclusively(
                                    before:TapGesture().onEnded {
                                        print("tapped")
                                        if let client = model.client {
                                            client.sendTapMovement(message: "tapped")
                                        }
                                    } )
                            )
                    )
                
                
                DrawShape(points: points)
                    .stroke(lineWidth: 2) // here you put width of lines
                    .foregroundColor(.secondary)
            }
        }
        
    }
    
    private func addNewPoint(_ value: DragGesture.Value) {
        // here you can make some calculations based on previous points
        points.append(value.location)
    }
    private func transformPoints(dragValue value : DragGesture.Value, environmentSize size: CGSize) -> Data? {
        let point = value.translation
        
        let data = "\(point.width),\(point.height)".data(using: .utf8)
        
        return data
    }
    
    
}


