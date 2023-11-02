//
//  URLRequestFactory.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

protocol URLRequestFactory {
    func makeRequest(for endpoint: EndPoint) -> URLRequest?
}

struct OpenAIURLRequestFactory: URLRequestFactory {
    private let builder: OpenAIURLComponents
    
    init(builder: OpenAIURLComponents) {
        self.builder = builder
    }
    
    
    
    func makeRequest(for endpoint: EndPoint) -> URLRequest? {
        do {
            let url: URL = try builder.build(for: endpoint)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            switch endpoint {
            case .chatCompletion(let prompt, let maxTokens):
                let payload: [String: Any] = [
                    "prompt": prompt,
                    "max_tokens": maxTokens
                ]
                let jsonData = try? JSONSerialization.data(withJSONObject: payload)
                request.httpBody = jsonData
            }
            return request
        } catch let error as NetworkingError {
            print("DEBUG: \(error.debugMessage)")
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
