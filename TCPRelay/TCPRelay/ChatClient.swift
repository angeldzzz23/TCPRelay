//
//  ChatClient.swift
//  TCPRelay
//
//  Created by angel zambrano on 6/14/25.
//

import Foundation

import Network

class ChatClient: ObservableObject {
    private var connection: NWConnection?
    @Published var receivedMessages: [String] = []

    func connect(host: String, port: UInt16) {
        let nwEndpoint = NWEndpoint.Host(host)
        let nwPort = NWEndpoint.Port(rawValue: port)!
        connection = NWConnection(host: nwEndpoint, port: nwPort, using: .tcp)

        connection?.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Connected to server")
                self.receive()
            default:
                break
            }
        }

        connection?.start(queue: .main)
    }

    func send(_ message: String) {
        let data = message.data(using: .utf8)!
        connection?.send(content: data, completion: .contentProcessed({ _ in }))
    }

    private func receive() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, _, _ in
            if let data = data, let message = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.receivedMessages.append(message)
                }
                self.receive() // Keep receiving
            }
        }
    }
}
