//
//  NetworkingServiceImp.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

class NetworkingServiceImp: ChatGPTNetworkingService {
    private let builder: OpenAIURLComponents
    private let factory: OpenAIURLRequestFactory
    private let networkingService: NetworkingService
    
    init(builder: OpenAIURLComponents, factory: OpenAIURLRequestFactory, networkingService: NetworkingService) {
        self.builder = builder
        self.factory = factory
        self.networkingService = BasicNetworkingService()
    }
    
    func fetchCompletion(for prompt: String, maxTokens: Int) async throws -> OpenAIResponse {
        guard let request = factory.makeRequest(for: .chatCompletion(prompt: prompt, maxTokens: maxTokens)) else {
            throw NetworkingError.couldNotMakeURL
        }
        let wireAPIResponse: WireAPIResponse = try await networkingService.fetch(urlRequest: request)
        return OpenAIResponse(from: wireAPIResponse)
    }
}
