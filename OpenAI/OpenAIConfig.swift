//
//  OpenAIConfig.swift
//  OpenAI
//
//  Created by Bryan Carvalho on 3/15/23.
//


import Foundation



struct OpenAIConfig {
    static let apiKey = "YOUR_API_KEY_HERE"
    static let baseURLString = "https://api.openai.com"
    static let apiVersion = "v1"
    
    static var endpointURL: URL {
        return URL(string: "\(baseURLString)/\(apiVersion)")!
    }
    
    static func createURLRequest(endpoint: String, method: String = "GET", headers: [String: String] = [:], parameters: [String: Any] = [:]) -> URLRequest {
        let urlString = "\(endpointURL)/\(endpoint)"
        var urlComponents = URLComponents(string: urlString)!
        if method == "GET" {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        if method != "GET" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        }
        return request
    }
    
    static func sendRequest<T: Decodable>(request: URLRequest, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
            let decoder = JSONDecoder.iso8601Decoder
            do {
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension JSONDecoder {
    static let iso8601Decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        return decoder
    }()
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }()
}

