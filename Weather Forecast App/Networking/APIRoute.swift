//
//  APIRoute.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//


import Foundation
import Alamofire

protocol APIRouteable: URLRequestConvertible {
    associatedtype Parameter: Encodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameter? { get }
    var parametersEncoder: ParameterEncoder { get }
}

extension APIRouteable {
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parametersEncoder: ParameterEncoder {
        return URLEncodedFormParameterEncoder()
    }
    
    var request: URLRequest {
        let url = URL(string: baseURL + path)!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = self.request
        request = try parametersEncoder.encode(parameters, into: request)
        return request
    }
}


