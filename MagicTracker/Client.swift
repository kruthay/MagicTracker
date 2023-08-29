//
//  Client.swift
//  MagicTracker
//
//  Created by Kruthay Donapati on 8/27/23.
//

import Foundation
import Network

class Client {
    var connection: NWConnection
    var queue : DispatchQueue
    
    init(name : String) {
        queue = DispatchQueue(label:"Client Queue")
        connection = NWConnection(to: .service(name: name, type: "_mouse._udp", domain: "local", interface: nil), using: .udp)
        
        connection.stateUpdateHandler = { [weak self] (newState) in
            switch(newState) {
            case .ready:
                print("Ready To Send")
                self?.sendInitialMovement()
            case .failed(let error):
                print("Client failed \(error)")
            default :
                print("Uknown Case")
                break
            }
            
        }
        connection.start(queue: queue)
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
}
