//
//  Client.swift
//  MagicTracker
//
//  Created by Kruthay Donapati on 8/27/23.
//

import Foundation
import Network

class Client : ObservableObject {
    var connection: NWConnection
    var queue : DispatchQueue
    @Published var message = ""
    init(endPoint : NWEndpoint) {
        queue = DispatchQueue(label:"Client Queue")
        connection = NWConnection(to : endPoint,using: .udp)
        
        connection.stateUpdateHandler = { (newState) in
            switch(newState) {
            case .ready:
                print("Ready To Send")
                self.sendInitialMovement()
            case .failed(let error):
                print("Client failed \(error)")
            case .preparing:
                print("Client preparing")
                print("\(String(describing: self.connection.parameters))")
            case .setup:
                print("Client setup")
            case .waiting(let error):
                print("Client failed \(error)")
            default :
                print("Uknown Case")
                break
            }
        }
        print("Before Connection Starts")
        connection.start(queue: queue)
    }
    deinit {
        connection.cancel()
    }
    func sendInitialMovement() {
        let helloMessage = "hello".data(using: .utf8)
        connection.send(content: helloMessage, completion: .contentProcessed({ error in
            if let error = error {
                print("Send error \(error)")
            }
            
        }))
        
        connection.receive(minimumIncompleteLength: 1, maximumLength: 100 ) { (content, context, isComplete, error) in
            if content != nil {
                print("Got Connected")
                self.message = "Connected"
                print("UI update")
            
            }
            
        }
    }
    
    func send(movements : [Data]) {
        connection.batch {
            for movement in movements {
                connection.send(content: movement, completion: .contentProcessed({ error in
                    if let error = error {
                        print("Batch Send error \(error)")
                    }
                }))
            }
        }
    }
}
