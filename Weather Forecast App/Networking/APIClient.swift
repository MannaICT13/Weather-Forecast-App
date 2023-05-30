//
//  APIClient.swift
//  Weather Forecast App
//
//  Created by Md Khaled Hasan Manna on 30/5/23.
//

import Foundation
import Alamofire

protocol GenericAPIClient {
    static func startRequest<T: Decodable>(
        with request: URLRequestConvertible,
        decoder: JSONDecoder,
        completion: @escaping (Result<T, AFError>) ->  Void)
}

extension GenericAPIClient {
    static func startRequest<T: Decodable>(
        with request: URLRequestConvertible,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<T, AFError>) ->  Void) {
            AF.request(request)
                .validate()
                .responseDecodable(of: T.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let decodable):
                        completion(.success(decodable))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
}
