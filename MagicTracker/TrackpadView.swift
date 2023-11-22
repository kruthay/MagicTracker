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
            if let client = model.client {
                
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .overlay (
                        TwoFingerTapView { gesture in
                            client.send(message: TouchInfo.rightTap.data)
                        }
                    )
                    .gesture(
                        
                        DragGesture()
                            .onChanged { value in
                                points.append(value.location)
                                client.send(message: TouchInfo.movement(value: value).data)
                            }
                            .onEnded { value in
                                withAnimation {
                                    self.points = []
                                }
                                client.send(message: TouchInfo.stoppedMovement.data)
                            }
                            .exclusively(
                                before: TapGesture(count: 2).onEnded {
                                    print("clicked")
                                    client.send(message: TouchInfo.click.data )
                                }.exclusively(
                                    before:TapGesture().onEnded {
                                        client.send(message: TouchInfo.tap.data)
                                    } )
                            )
                    )
                
                
                DrawShape(points: points)
                    .stroke(lineWidth: 4) // here you put width of lines
                    .foregroundColor(.secondary)
            }
        }
        
    }
    
}


