//
//  Model.swift
//  MagicMovement
//
//  Created by Kruthay Donapati on 8/28/23.
//

import Foundation
import Network

class Model: ObservableObject {
    @Published var text: String = ""
    @Published var client : Client?
    
    private var browserQ: NWBrowser?

    func log(_ string: String) {
        print(string)
        text.append(string + "\n")
    }

    func startBrowser() -> NWBrowser {
        log("browser will start")
        let browser = NWBrowser(for: .bonjour(type: "_mouse._udp", domain: nil), using: .udp)
        browser.stateUpdateHandler = { newState in
            self.log("brower did change state, new: \(newState)")
        }
        browser.browseResultsChangedHandler = { results, changes in
            for result in results {
                self.log("brower did change results, new: \(result.endpoint)")
                self.client = Client(endPoint: result.endpoint)
            }
            self.log("browser changes \(changes)")
        }
        browser.start(queue: .main)
        return browser
    }
    
    func stopBrowser(browser: NWBrowser) {
        log("browser will stop")
        browser.stateUpdateHandler = nil
        browser.cancel()
    }

    func startStopBrowser() {
        if let browser = browserQ {
            browserQ = nil
            stopBrowser(browser: browser)
        } else {
            browserQ = startBrowser()
        }
    }

    var isBrowserStarted: Bool {
        browserQ != nil
    }


}
