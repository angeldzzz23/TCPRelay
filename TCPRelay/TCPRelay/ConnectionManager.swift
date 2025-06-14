//
//  ConnectionManager.swift
//  TCPRelay
//
//  Created by angel zambrano on 6/14/25.
//

import Foundation
import Network
import Darwin


// this will be in charge of all of our connections

class ConnectionManager {
    static let shared = ConnectionManager()
    private var connections: [Int: NWConnection] = [:]
    private var nextId = 1
    

    private var listener: NWListener?
    private var listenerPort: UInt16?
    
    // this starts listening on my device + port number
    // also checks if the user is already using that port
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
    func connect(to host: String, port: UInt16) -> Int? {
          guard let nwPort = NWEndpoint.Port(rawValue: port) else {
              print("Invalid port: \(port)")
              return nil
          }
          
          let endpoint = NWEndpoint.Host(host)
          let connection = NWConnection(host: endpoint, port: nwPort, using: .tcp)
          
          let connectionId = nextId
          nextId += 1
          connections[connectionId] = connection
          
          connection.stateUpdateHandler = { (state: NWConnection.State) in
              switch state {
              case .ready:
                  print("[\(connectionId)] Connected to \(host):\(port)")
                  self.receive(connection, id: connectionId)
              case .failed(let error):
                  print("[\(connectionId)] Connection failed: \(error)")
                  self.connections.removeValue(forKey: connectionId)
              case .cancelled:
                  print("[\(connectionId)] Connection cancelled")
                  self.connections.removeValue(forKey: connectionId)
              default:
                  break
              }
          }
          
          connection.start(queue: DispatchQueue.main)
          return connectionId
      }
    
    // this will send Connection
    func receive(_ connection: NWConnection, id: Int) {
        
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, context, isComplete, error in
            
            if let error = error {
                print("[\(id)] Receive error: \(error)")
                self.connections.removeValue(forKey: id)
                return
            }
            
            if let data = data, !data.isEmpty {
                if let message = String(data: data, encoding: .utf8) {
                    print("[\(id)] Received: \(message)")
                } else {
                    print("[\(id)] Received \(data.count) bytes of binary data")
                }
            }
            
            if isComplete {
                print("[\(id)] Connection completed")
                self.connections.removeValue(forKey: id)
            } else {
                // Continue receiving more data
                self.receive(connection, id: id)
            }
        }
    }
    
    
    func listConnections() {
        
        func getAllConnectionIds() -> [Int] {
                return Array(connections.keys).sorted()
        }
        
        print("Connections: \(getAllConnectionIds())")
    }
    
    func send(to id: Int, message: String) {
         guard let data = message.data(using: .utf8) else {
             print("[\(id)] Failed to convert message to data")
             return
         }
         send(to: id, data: data)
     }
    
    
    func send(to id: Int, data: Data) {
           guard let connection = connections[id] else {
               print("[\(id)] Connection not found")
               return
           }
           
           connection.send(content: data, completion: .contentProcessed { error in
               if let error = error {
                   print("[\(id)] Send error: \(error)")
                   self.connections.removeValue(forKey: id)
               } else {
                   print("[\(id)] Sent \(data.count) bytes of binary data")
               }
           })
       }
    
    // terminates connection
    func terminate(id: Int) {
        
        guard let connection = connections[id] else {
            print("[\(id)] Connection not found")
            return
        }
        
        connection.cancel()
        connections.removeValue(forKey: id)
        print("[\(id)] Connection terminated")
        
    }
    
    // exists all connections
    
    func exitAll() {
       // exit all
    }
    
    
    // returns Ip of user
    func myIp() -> String {
           
        
           var address = "127.0.0.1"
           
           var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
           guard getifaddrs(&ifaddr) == 0 else {
               print("Failed to get network interfaces")
               return address
           }
        
           defer { freeifaddrs(ifaddr) }
           
           var ptr = ifaddr
        
           while ptr != nil {
               
               let interface = ptr!.pointee
               let addrFamily = interface.ifa_addr.pointee.sa_family
               
               if addrFamily == UInt8(AF_INET) {
                   
                   let name = String(cString: interface.ifa_name)
                   
                   if name == "en0" || name == "wlan0" || name == "eth0" {
                       var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                       getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                  &hostname, socklen_t(hostname.count),
                                  nil, socklen_t(0), NI_NUMERICHOST)
                       address = String(cString: hostname)
                       break
                   }
               }
               ptr = interface.ifa_next
           }
           
        
           return address
       }
    
    
    
    
}
