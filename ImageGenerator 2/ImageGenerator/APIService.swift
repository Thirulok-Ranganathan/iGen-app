//
//  APIService.swift
//  ImageGenerator
//
//  Created by RITSJC-017 on 30/03/23.
//

import UIKit

struct Response: Decodable {
    let data: [ImageURL]
}

struct ImageURL: Decodable {
    let url: String
}

enum APIError: Error {
    case unableToCreateImageURL
    case unableToConvertDataIntoImage
    case unableToCreateURLForURLReequest
}

class APIService{
    let apiKey = "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"
    
    func fetchImageForPrompt(_ prompt: String) async throws -> UIImage{
        let fetchImageURL = "https://api.openai.com/v1/images/generations"
        let urlRequest = try createURLRequestFor(httpMethod: "POST", url: fetchImageURL, prompt: prompt)
        
        let (data, response)  = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        let results = try decoder.decode(Response.self, from: data)
        
        let imageURL = results.data[0].url
        
        guard let imageURL = URL(string: imageURL) else {
            throw APIError.unableToCreateImageURL
        }
        
        let (imageData, imageResponse) = try await URLSession.shared.data(from: imageURL)
        
        guard let image = UIImage(data: imageData) else{
            throw APIError.unableToConvertDataIntoImage
        }
        return image
    }
    
    private func createURLRequestFor(httpMethod: String,  url: String, prompt: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw APIError.unableToCreateURLForURLReequest
        }
        
        var urlRequest = URLRequest(url: url)
        
        //Method
        urlRequest.httpMethod = httpMethod
        
        //Headers
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Body
        let jsonBody: [String: Any] = [
            "prompt": "\(prompt)",
            "n": 1,
            "size": "1024x1024"
        ]
        
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        
        return urlRequest
        
        
        
    }
}
