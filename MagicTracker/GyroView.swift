//
//  GyroView.swift
//  MagicTracker
//
//  Created by Kruthay Donapati on 9/17/23.
//

import Foundation
import CoreMotion
import SwiftUI

struct GyroView: View {

    @ObservedObject var model = Model()
    let motion = CMMotionManager()
    @State var timer : Timer?
    
    @State var values = (x: 0.2, y: 0.4, z: 0.2)


    var body: some View {

        Button("StartGyro") {
            startDeviceMotion()
        }
        ZStack {
            
            Text("\(values.x),\(values.y), \(values.z)")
        }

        }
     func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 50.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            self.timer = Timer(fire: Date(), interval: (1.0 / 50.0), repeats: true,
                               block: { (timer) in
                if let data = self.motion.deviceMotion {
                                    // Get the attitude relative to the magnetic north reference frame.
                                    let x = data.attitude.pitch
                                    let y = data.attitude.roll
                                    let z = data.attitude.yaw
                    if abs(values.x - x) > 0.1 * (values.x) || abs(values.y - y) > 0.1 * (values.z) || abs(values.z - z) > 0.1 * (values.z) {
                        values = (x,y,z)
                        print(x,y,z)
                    }
                                    
                                    // Use the motion data in your app.
                                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        }
        
    }
    
    func processValues(_ x : Double, _ y: Double, _ z : Double) {
        
    }

    }
    
#Preview {
    GyroView(model: Model(), timer: Timer())
}
