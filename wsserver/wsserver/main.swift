//
//  main.swift
//  wsserver
//
//  Created by JieLiang Ma on 2020/2/17.
//  Copyright © 2020 JieLiang Ma. All rights reserved.
//

import Foundation

let semaphore = DispatchSemaphore(value: 0)

class WebServerDelegate: NSObject, MBWebSocketServerDelegate {
    func webSocketServer(_ webSocketServer: MBWebSocketServer!, didAcceptConnection connection: GCDAsyncSocket!) {
        print("connected: \(connection.connectedHost() ?? "")")
        
        guard let data = NSData(contentsOfFile: "/Users/jl/study/MBWebSocketServer/wsserver/wsserver/heartbeat.json") as Data? else {
            return
        }
        
        webSocketServer.send(data)
    }
    
    func webSocketServer(_ webSocketServer: MBWebSocketServer!, clientDisconnected connection: GCDAsyncSocket!) {
        print("disconnected: \(connection.connectedHost() ?? "")")
//        semaphore.signal()
    }
    
    func webSocketServer(_ webSocket: MBWebSocketServer!, didReceive data: Data!, fromConnection connection: GCDAsyncSocket!) {
        guard data.count > 0, let string = String(data: data, encoding: .utf8) else {
            return
        }
        
        print("received: \(string)")
        if string == "hello" {
            webSocket.send("world".data(using: .utf8))
        }
    }
    
    func webSocketServer(_ webSocketServer: MBWebSocketServer!, couldNotParseRawData rawData: Data!, fromConnection connection: GCDAsyncSocket!, error: Error!) {
        
    }
    
}

let delegate = WebServerDelegate()
let server = MBWebSocketServer(port: 8080, delegate: delegate)

semaphore.wait()
