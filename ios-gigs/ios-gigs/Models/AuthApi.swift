//
//  AuthApi.swift
//  ios-gigs
//
//  Created by Joshua Sharp on 9/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct AuthUser: Encodable {
    let username: String
    let password: String
}

class AuthAPI {

    struct Bearer: Codable {
        let token: String
    }
    
    private(set) var bearer: Bearer?
    
    var isSignedIn: Bool {
        if let _ = bearer {
            return true
        } else {
            return false
        }
    }
    
    let baseURL = URL(string:"https://lambdagigs.vapor.cloud/api")!
    
    func signup (with user:AuthUser, completion: @escaping (NetworkError?) -> Void) {
        let signupURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        var request = URLRequest(url: signupURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            // Convert the User object into JSON data.
            let userData = try encoder.encode(user)
            
            // Attach the user JSON to the URLRequest
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.responseError)
                return
            }
            
            if let error = error {
                NSLog("Error creating user on server: \(error)")
                completion(.otherError)
                return
            }
            completion(nil)
            }.resume()
        
    }
    
    func signin (with user: AuthUser, completion: @escaping (NetworkError?) -> Void) {
        // Set up the URL
        let signinURL = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("login")
        
        // Set up a request
        var request = URLRequest(url: signinURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(.encodingError)
            return
        }
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Handle errors
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                if response.statusCode  == 401 {
                        completion(.loginError)
                } else {
                    completion(.responseError)
                }
                print ("Status code: \(response.statusCode)")
                return
            }
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(.loginError)
                return
            }
            
            // (optionally) handle the data returned
            guard let data = data else {
                completion(.noData)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                completion(.noDecode)
                return
            }
            completion(nil)
            }.resume()
    }
}
