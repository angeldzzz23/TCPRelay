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

printHelp()
