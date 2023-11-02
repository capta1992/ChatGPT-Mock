//
//  NetworkingService.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

protocol NetworkingService {
    func fetch<T: Decodable>(urlRequest: URLRequest) async throws -> T
}
