import UIKit

// Define a struct to represent the response data returned by the API
struct Response: Decodable {
    let data: [ImageURL]
}

// Define a struct to represent an image URL returned by the API
struct ImageURL: Decodable {
    let url: String
}

// Define an enum to represent errors that might occur during API calls
enum APIError: Error {
    case unableToCreateImageURL
    case unableToConvertDataIntoImage
}

// Define a class to encapsulate API functionality
class APIService{
    // Define a constant property to store the API key
    let apikey = "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"
    
    // Define an asynchronous function to fetch an image for a given prompt
    func fetchImageForPrompt(_ prompt: String) async throws -> UIImage{
        // Define the URL for the API endpoint to generate an image
        let fetchImageURL = "https://api.openai.com/v1/images/generations"
        
        // Create a URL request for the API endpoint using the given prompt
        let urlRequest = try createURLRequestFor(httpMethod: "POST", url: fetchImageURL, prompt: prompt)
        
        // Send the API request and await the response
        let (data, response)  = try await URLSession.shared.data(for: urlRequest)
        
        // Decode the response data into a struct representing the API response
        let decoder = JSONDecoder()
        let results = try decoder.decode(Response.self, from: data)
        
        // Extract the image URL from the response
        let imageURL = results.data[0].url
        
        // Create a URL object from the image URL string
        guard let imageURL = URL(string: imageURL) else {
            throw APIError.unableToCreateImageURL
        }
        
        // Fetch the image data from the image URL
        let (imageData, imageResponse) = try await URLSession.shared.data(from: imageURL)
        
        // Convert the image data into a UIImage object
        guard let image = UIImage(Data: imageData) else{
            throw APIError.unableToConvertDataIntoImage
        }
        
        // Return the fetched image
        return image
    }
    
    // Define a private function to create a URL request for the API endpoint
    private func createURLRequestFor(httpMethod: String,  url: String, prompt: String) throws -> URLRequest {
        // ...
    }
}
