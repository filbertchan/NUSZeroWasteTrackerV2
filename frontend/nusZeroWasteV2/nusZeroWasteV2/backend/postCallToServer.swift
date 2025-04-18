//
//  postCallToServer.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 4/9/24.
//

import Foundation

func detectDigit(imageData: Data, completion: @escaping (Result<[Int], Error>) -> Void) {
    let url = URL(string: "http://192.168.50.223:8501/number_extraction")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            return
        }
        let responseString = String(data: data, encoding: .utf8) ?? "No data"
        print("Response string: \(responseString)")
        
        do {
            // Parse JSON response
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Int] {
                completion(.success(jsonArray))
            } else {
                // Handle unexpected format
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format"])))
            }
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}
  

