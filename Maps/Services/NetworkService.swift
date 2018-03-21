//
//  NetworkService.swift
//  Maps
//
//  Created by Bodya on 19.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import Foundation

class NetworkService {
    
    var urlComponents : URLComponents!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    init(_ urlString: String) {
        urlComponents = URLComponents(string: urlString)
    }
    
    func getRequest(parameters : [URLQueryItem], complition : @escaping (_ data : Data) -> Void) -> Void {
        urlComponents.queryItems = parameters
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest) { (data : Data!, response : URLResponse!, error : Error!) in
            if let data = data {
                complition(data)
            }
        }
        task.resume()
    }
    
    
    
}
