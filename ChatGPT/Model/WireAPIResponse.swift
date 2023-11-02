//
//  WireAPIResponse.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

enum Sender: Codable {
    case user
    case chatbot
}

struct WireAPIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
    let sender: Sender
}

struct Message: Codable {
    let content: String
}

var messages: [Message] = []
