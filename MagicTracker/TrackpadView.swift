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
    @ObservedObject var model = Model()
    @State private var startPoint: CGPoint = .zero

    var body: some View {


        ZStack {
            GeometryReader { proxy in
                Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .gesture(DragGesture().onChanged( { value in
                        self.addNewPoint(value)

                        if let data = transformPoints(dragValue : value, environmentSize : proxy.size) {
                            if let client = model.client {
                                client.send(movements: [data])
                            }
                        }
                        else {
                            print("Not Working")
                        }
                    })
                        .onEnded( { value in
                            self.points = []
                            if let client = model.client {
                                client.sendLastMovement()
                            }
                        }))
                    .onTapGesture {
                        print("tapped")
                        if let client = model.client {
                            client.sendTapMovement()
                        }
                    }
                
                
                DrawShape(points: points)
                    .stroke(lineWidth: 2) // here you put width of lines
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            model.startStopBrowser()
        }

    }

    private func addNewPoint(_ value: DragGesture.Value) {
        // here you can make some calculations based on previous points
        points.append(value.location)
    }
    private func transformPoints(dragValue value : DragGesture.Value, environmentSize size: CGSize) -> Data? {

        
        let point = value.translation
        
        let data = "\(point.width),\(point.height)".data(using: .utf8)
        print(point)
        return data ?? nil
    }
    

}

struct DrawShape: Shape {

    var points: [CGPoint]

    // drawing is happening here
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }

        path.move(to: firstPoint)
        for pointIndex in 1..<points.count {
            path.addLine(to: points[pointIndex])

        }
        return path
    }
}
