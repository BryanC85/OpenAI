//
//  OpenAIClient.swift
//  OpenAI
//
//  Created by Quakly on 3/15/23.
//

import Foundation

class OpenAIClient {
    let apiKey: String
    let endpointURL = URL(string: "https://api.openai.com/v1")!
    let session = URLSession.shared
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func generateCompletion(prompt: String, model: String, temperature: Double? = nil, maxTokens: Int? = nil, completion: @escaping (Result<CompletionResponse, Error>) -> Void) {
        var request = URLRequest(url: endpointURL.appendingPathComponent("completions"))
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let requestBody: [String: Any] = [
            "prompt": prompt,
            "model": model,
            "temperature": temperature ?? 0.5,
            "max_tokens": maxTokens ?? 16
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: requestBody, options: [])
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                      completion(.failure(OpenAIError.invalidServerResponse))
                      return
                  }
            guard let data = data else {
                completion(.failure(OpenAIError.invalidData))
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let response = try decoder.decode(CompletionResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

enum OpenAIError: Error {
    case invalidServerResponse
    case invalidData
    case networkError(Error)
    case apiError(String)
}

struct CompletionResponse: Codable {
    let id: String
    let createdAt: String
    let model: String
    let choices: [CompletionChoice]
}

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
