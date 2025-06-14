# 🕸️ TCP Relay

A Swift-based command-line tool for creating and managing TCP connections. This utility allows your macOS machine to act as both a **TCP server** and a **TCP client**, making it easy to establish, list, communicate with, and terminate TCP socket connections interactively.


----------


## Inpiration

i’ve built a similar project in Java using Socket and ServerSocket, so I was curious how Swift would approach the same kind of networking challenge. Exploring this with Swift was a fun way to learn how Apple abstracts lower-level networking and system capabilities.

# import Network 

This is Apple’s modern networking framework, designed to replace low-level socket APIs like BSD sockets. I used it to handle TCP connections—creating both a server (listener) and clients (connectors). It makes working with sockets in Swift much cleaner and more high-level compared to using raw C APIs.

# import Darwin

Darwin gives access to lower-level C APIs and system calls. I used it specifically for fetching the device’s IP address using functions like getifaddrs and getnameinfo, similar to how you might access system networking interfaces in C or POSIX-style environments.

## Features

- Start a TCP server on a specified port.
- Connect to remote TCP servers.
- Send messages to any active connection.
- Receive messages from connected clients.
- List and manage active connections.
- Print your local IP address.
- Gracefully exit all connections.

---

Example of project: 

<img width="993" alt="Screenshot 2025-06-14 at 1 28 02 PM" src="https://github.com/user-attachments/assets/6c75175d-b127-444e-ac67-af707e8bff0b" />


## 🛠️ Getting Started

### ⚙️ Requirements

- macOS with Swim
- Command-line environment (Terminal or iTerm)

### 🧪 Running the Tool

Clone or download the project and run it with:

```bash
swift run

or with xcdoe
