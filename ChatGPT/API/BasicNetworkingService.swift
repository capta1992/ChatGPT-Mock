//
//  BasicNetworkingService.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

class BasicNetworkingService: NetworkingService {
    func fetch<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        guard let url = urlRequest.url else { throw NetworkingError.couldNotMakeURL }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw NetworkingError.noHttpResponse
        } else {
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}
