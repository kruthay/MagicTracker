//
//  DrawShape.swift
//  MagicTracker
//
//  Created by Kruthay Kumar Reddy Donapati on 11/18/23.
//

import SwiftUI

struct DrawShape: Shape {
    var points: [CGPoint]
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
