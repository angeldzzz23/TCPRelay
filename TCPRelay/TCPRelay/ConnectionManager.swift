//
//  ConnectionManager.swift
//  TCPRelay
//
//  Created by angel zambrano on 6/14/25.
//

import Foundation
import Network


// this will be in charge of all of our connections

class ConnectionManager {
    static let shared = ConnectionManager()
    private var connections: [Int: NWConnection] = [:]
    private var nextId = 1
    
    private var listener: NWListener?
    private var listenerPort: UInt16?
    
    func startListening(on port: UInt16) {
        
    }
    
    // Serve as my connect method
    func connect(to host: String, port: UInt16) {
        // TODO:
    }
    
    // serve as receive method
    func receive(_ connection: NWConnection, id: Int) {
        // TODO:
    }
    
    func listConnections() {
        // TODO:
    }
    
    
    func send(to id: Int, message: String) {
        // TODO:
    }
    
    // terminates connection
    func terminate(id: Int) {
        
        // TODO:
    }
    
    // exists all connections
    
    func exitAll() {
       // exit all
    }
    
    
    // returns Ip of user
    func myIp() {
        
    }
    
    
}
