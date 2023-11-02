//
//  EndPoint.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/30/23.
//

import Foundation

enum EndPoint {
    case chatCompletion(prompt: String, maxTokens: Int)
}
