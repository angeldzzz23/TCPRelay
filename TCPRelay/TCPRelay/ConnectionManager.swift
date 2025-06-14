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
    
    
    
    
}
