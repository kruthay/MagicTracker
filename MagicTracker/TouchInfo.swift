//
//  TapMessage.swift
//  MagicTracker
//
//  Created by Kruthay Kumar Reddy Donapati on 11/22/23.
//

import Foundation
import SwiftUI

enum TouchInfo {
    
    case movement( value :  DragGesture.Value)
    
    case tap
    
    case rightTap
    
    case click
    
    case scroll
    
    case stoppedMovement
    
    
    var message : String {
        switch(self) {
            
        case .movement(let value):
            return "\(value.translation.width),\(value.translation.height)"
        case .tap:
            return "tap"
        case .rightTap:
            return "rightTap"
        case .click:
            return "click"
        case .scroll:
            return "scroll"
            
        case .stoppedMovement:
            return "lifted"
        }
    }
    
}

extension TouchInfo {

    var data: Data {
        return self.message.data(using: .utf8)!
    }
}
