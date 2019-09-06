//
//  GigController.swift
//  ios-gigs
//
//  Created by Joshua Sharp on 9/5/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

class GigController {
    var gigs: [Gig] = []
    
    let baseURL = URL(string:"https://lambdagigs.vapor.cloud/api")!
    
    func getAllGigs (bearer: Bearer, completion: @escaping (NetworkError?) -> Void) {
        let requestURL = baseURL.appendingPathComponent("gigs")
        var request = URLRequest(url: requestURL)
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    if response.statusCode == 401 {
                        completion (.noAuth)
                    } else {
                        completion(.responseError)
                    }
                }
            }
            if let error = error {
                NSLog("There was a network request error: \(error)")
                completion(.otherError)
            }
            
            guard let data = data else {
                completion(.noData)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                self.gigs = try decoder.decode([Gig].self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(.encodingError)
                return
            }
        }.resume()
        
    }
}
