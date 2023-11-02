//
//  OpenAIResponse.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

struct OpenAIResponse {
    let content: String
    
    init(from wireModel: WireAPIResponse) {
        self.content = wireModel.choices.first?.message.content ?? ""
    }
}
