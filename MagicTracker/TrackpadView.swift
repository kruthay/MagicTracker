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
    @State var lastPoint : CGPoint = .zero

    var body: some View {


        ZStack {
            GeometryReader { proxy in
                Rectangle() // replace it with what you need
                    .edgesIgnoringSafeArea(.all)
                    .gesture(DragGesture().onChanged( { value in
                        self.addNewPoint(value)
//                        lastPoint = value.location
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
                            // here you perform what you need at the end
                            self.points = []

                            lastPoint.x = value.translation.width
                            lastPoint.y = value.translation.height
                        }))
                
                
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
        
//        var point : CGSize = CGSize(width: value.location.x, height: value.location.y)
        var point = value.location
        print(point)
        print(lastPoint)
        point.x = lastPoint.x + value.translation.width
        point.y = lastPoint.y + value.translation.height
//        print(size)
//        point.width = (-point.width + size.width / size.width )
//        point.height = (-point.height + size.height / size.height)
//        point = (size - point ) / size
//

        
//        let data = "\(point.width),\(point.height)".data(using: .utf8)
          let data = "\(point.x),\(point.y)".data(using: .utf8)
        
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
