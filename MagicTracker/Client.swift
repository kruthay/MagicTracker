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
    init(endPoint : NWEndpoint) {
        queue = DispatchQueue(label:"Client Queue")
        connection = NWConnection(to : endPoint,using: .udp)
        
        connection.stateUpdateHandler = { (newState) in
            switch(newState) {
            case .ready:
                self.send(message: "Ready To Send".data(using: .utf8)! )
            case .failed(let error):
                print("Client failed \(error)")
            case .preparing:
                print("Client preparing")
            case .setup:
                print("Client setup")
            case .waiting(let error):
                print("Client failed \(error)")
            default :
                print("Uknown Case")
                break
            }
        }
        connection.start(queue: queue)
    }
    deinit {
        connection.cancel()
    }
        
    func send(message movement: Data) {
        connection.send(content: movement, completion: .contentProcessed({ error in
            if let error = error {
                print("Send error \(error)")
            }
        }))
        
        connection.receive(minimumIncompleteLength: 1, maximumLength: 100 ) { (content, context, isComplete, error) in
            if content != nil {
                print(content?.debugDescription ?? "Recieved Conformation")
            }
        }
    }
}
