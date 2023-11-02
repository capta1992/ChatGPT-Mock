//
//  ChatGPTNetworkingService.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

protocol ChatGPTNetworkingService {
    func fetchCompletion(for prompt: String, maxTokens: Int) async throws -> OpenAIResponse
}
