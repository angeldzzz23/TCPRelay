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
        
        guard listener == nil else {
            print("Listener already running on port \(listenerPort ?? 0)")
            return
        }
        
        do {
        
            let nwPort = NWEndpoint.Port(rawValue: port)!
            listener = try NWListener(using: .tcp, on: nwPort)
            listenerPort = port

            listener?.newConnectionHandler = { newConnection in
                newConnection.start(queue: .main)
                print("[Server] New incoming connection from \(newConnection.endpoint)")
                self.connections[self.nextId] = newConnection
                self.receive(newConnection, id: self.nextId)
                print("[\(self.nextId)] Accepted incoming connection")
                self.nextId += 1
            }

            listener?.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    print("Server listening on port \(port)")
                case .failed(let error):
                    print("Listener failed: \(error)")
                    self.listener = nil
                default: break
                }
            }

            listener?.start(queue: .main)

        } catch {
            print("Failed to start listener: \(error)")
        }
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
