//
//  Typealias.swift
//  ChatGPT
//
//  Created by Lawson Falomo on 10/31/23.
//

import Foundation

typealias OpenAICompletion = (Result<OpenAIResponse, NetworkingError>) -> Void
typealias WireAPIResult<T: Decodable> = (Result<T, NetworkingError>) -> Void
