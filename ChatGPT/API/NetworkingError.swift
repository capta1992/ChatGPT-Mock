//
//  NetworkingError.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/30/23.
//

import Foundation

enum NetworkingError: Error, Equatable {
    case couldNotMakeURL
    case noData
    case noHttpResponse
    case networkingFailure(Error)
    case serialize(Error)
    case mappingModels(Error)
    
    var debugMessage: String {
        switch self {
        case .couldNotMakeURL:
            return "DEBUG: Could not make the url provided"
        case .noData:
            return "DEBUG: Could not find data from api request"
        case .noHttpResponse:
            return "DEBUG: No Http Response from API request"
        case .networkingFailure(let error):
            return "Networking Failure \(error.localizedDescription)"
        case .serialize(let error):
            return "Serialization Error \(error.localizedDescription)"
        case let .mappingModels(error):
            return "Could not map wire model to data model: \(error.localizedDescription)"
        }
    }
    static func == (lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        lhs.debugMessage == rhs.debugMessage
    }
}
