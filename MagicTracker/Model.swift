//
//  Model.swift
//  MagicMovement
//
//  Created by Kruthay Donapati on 8/28/23.
//

import Foundation
import Network

class Model: ObservableObject {
    var client : Client?
    @Published var devicesFound: [String: NWEndpoint] = [:]
    
    private var browserQ: NWBrowser?
    
    func log(_ string: String) {
        print(string)
    }
    
    func startBrowser()  {
        if browserQ != nil {
            return
        }
        
        log("browser will start")
        let browser = NWBrowser(for: .bonjour(type: "_mouse._udp", domain: nil), using: .udp)
        let params = browser.parameters
        params.allowLocalEndpointReuse = true
        params.allowFastOpen = true
        params.includePeerToPeer = true
        browser.stateUpdateHandler = { newState in
            self.log("brower did change state, new: \(newState)")
        }
        browser.browseResultsChangedHandler = { results, changes in
            for result in results {
                if let stringResult = result.endpoint.debugDescription.split(separator: ".").first {
                    self.devicesFound[String(stringResult)] = result.endpoint
                }
                self.log("brower did change results, new: \(result.endpoint)")
            }
            self.log("browser changes \(changes)")
        }
        browser.start(queue: .main)
        browserQ = browser
        
    }
    
    func connect(to connection: String) {
        if let endpoint = devicesFound[connection] {
            self.client = Client(endPoint: endpoint)
        }
    }
    
    func stopBrowser(){
        if let browser = browserQ {
            browserQ = nil
            browser.stateUpdateHandler = nil
            browser.cancel()
        }
    }
    
    func stopConnection() {
        client = nil
    }
    
    var isBrowserStarted: Bool {
        browserQ != nil
    }

}
