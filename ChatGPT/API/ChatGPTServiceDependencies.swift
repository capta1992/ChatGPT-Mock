//
//  ChatGPTServiceDependencies.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

enum ChatGPTServiceDependencies {
    private static let builder: OpenAIURLComponents = OpenAIURLComponents()
    private static let factory: OpenAIURLRequestFactory = OpenAIURLRequestFactory(builder: builder)
    private static let networkingService: NetworkingServiceImp = NetworkingServiceImp(builder: builder, factory: factory, networkingService: networkingService as! NetworkingService)
    static let chatGptService: ChatGPTNetworkingService = networkingService
}
