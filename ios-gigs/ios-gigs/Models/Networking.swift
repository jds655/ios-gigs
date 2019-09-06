//
//  Networking.swift
//  ios-gigs
//
//  Created by Joshua Sharp on 9/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case put    = "PUT"
    case post   = "POST"
    case delete = "DELETE"
}

enum NetworkError:String, Error {
    case encodingError = "There was an error encoding data"
    case responseError = "There was an error with the network response"
    case otherError = "Some other error occured"
    case noData = "There was no data returned from the request"
    case noDecode = "There was an error decoding data"
    case loginError = "There was an error signing in"
    case noTaken = "There was no bearer token"
    case noAuth = "You are not authorized to do this"
}

