//
//  OpenAIDataModel.swift
//  OpenAI
//
//  Created by Quakly on 3/15/23.
//

import Foundation

class OpenAIDataModel {
    let apiKey: String
    let baseURLString = "https://api.openai.com"
    let apiVersion = "v1"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    struct Completion: Codable {
        let id: String
        let createdAt: String
        let model: String
        let choices: [CompletionChoice]
        
        struct CompletionChoice: Codable {
            let text: String
            let index: Int
            let logprobs: LogProbs
            let finishReason: String
            
            enum CodingKeys: String, CodingKey {
                case text
                case index = "index"
                case logprobs
                case finishReason = "finish_reason"
            }
        }
        
        struct LogProbs: Codable {
            let tokens: [String]
            let tokenLogprobs: [Double]
            let topLogprobs: [Double]
            let textOffset: [Int]
            let leftContext: [String]
            let rightContext: [String]
        }
    }
}
