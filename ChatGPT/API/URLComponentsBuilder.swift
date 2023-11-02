//
//  URLComponentsBuilder.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/30/23.
//

import Foundation

protocol URLComponentsBuilder {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
}

struct OpenAIURLComponents: URLComponentsBuilder {
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.openai.com"
    }
    
    var path: String {
        "/v1/chat/completions"
    }
    
    public func build(for endpoint: EndPoint) throws -> URL {
        guard let url = URLComponents().url else { throw NetworkingError.couldNotMakeURL }
        return url
    }
}
