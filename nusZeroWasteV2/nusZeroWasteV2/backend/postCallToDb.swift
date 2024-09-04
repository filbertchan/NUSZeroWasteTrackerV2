//
//  postCallToDb.swift
//  nusZeroWasteV2
//
//  Created by Beng Beng on 6/9/24.
//

import Foundation

func postData(binCenterName: String, extractedWeight: Double, completion: @escaping (Result<String, Error>) -> Void) {
    // Replace with your actual backend URL
    let url = URL(string:  "http://192.168.50.223:8501/insertData")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Create the JSON payload
    let payload: [String: Any] = [
        "binCenterName": binCenterName,
        "extractedWeight": extractedWeight,
        "manualWeight": 0,
        "collectionTime": "NULL",
        "latitude": 0.0,
        "longitude": 0.0,
        "selectedSession": "NULL",
        "selectedReportingType": "NULL",
    ]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            return
        }
        
        let responseString = String(data: data, encoding: .utf8) ?? "No response"
        print("Response string: \(responseString)")
        
        // Handle the response as needed
        if (response as? HTTPURLResponse)?.statusCode == 201 {
            completion(.success("Data posted successfully"))
        } else {
            // Handle unexpected status codes or response formats
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response"])))
        }
    }
    task.resume()
}
