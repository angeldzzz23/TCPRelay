//
//  main.swift
//  TCPRelay
//
//  Created by angel zambrano on 6/14/25.
//

import Foundation

func printHelp() {
    print("""
    Commands:
    start <port>               - Start TCP server on port 
    connect <ip> <port>       - Connect to a TCP server
    send <id> <message>       - Send message to connection id
    list                      - List all connections
    terminate <id>            - Terminate connection by id
    myip                      - Show local IP
    myport                    - Show active port(s)
    exit                      - Close all and exit
    help                      - Show this help
    """)
}


func commandLoop() {
    
    DispatchQueue.global(qos: .background).async {
        while true {
            print("> ", terminator: "")
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !input.isEmpty else { continue }

            let parts = input.split(separator: " ", maxSplits: 2).map(String.init)

            switch parts.first?.lowercased() {
                
            case "start":
                if parts.count == 2, let port = UInt16(parts[1]) {
                    ConnectionManager.shared.startListening(on: port)
                } else {
                    print("Usage: start <port>")
                }
            case "help":
                printHelp()
            case "connect":
                if parts.count == 3, let port = UInt16(parts[2]) {
                    ConnectionManager.shared.connect(to: parts[1], port: port)
                } else {
                    print("Usage: connect <ip> <port>")
                }
            case "list":
                ConnectionManager.shared.listConnections()
            case "myip":
                ConnectionManager.shared.myIp()
            case "myport":
                print("my port")
//                ConnectionManager.shared.myPort()
            case "send":
                if parts.count == 3, let id = Int(parts[1]) {
                    ConnectionManager.shared.send(to: id, message: parts[2])
                } else {
                    print("Usage: send <id> <message>")
                }
            case "terminate":
                if parts.count == 2, let id = Int(parts[1]) {
                    ConnectionManager.shared.terminate(id: id)
                } else {
                    print("Usage: terminate <id>")
                }
            case "exit":
                ConnectionManager.shared.exitAll()
                exit(0)
            default:
                print("Unknown command. Type 'help' for available commands.")
            }
        }
    }

    dispatchMain() // Keeps the app running
}

commandLoop()
