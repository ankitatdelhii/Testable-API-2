//
//  ApiClient2.swift
//  Testable API2
//
//  Created by Ankit Saxena on 05/03/23.
//

import Foundation

class ApiClient2 {
    
    //MARK: Properties
    let session: URLSession
    
    //MARK: Lifecycle
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func postAPI<REQ: Encodable, RES: Decodable>(url: URL, requestData: REQ, responseDataType: RES.Type, response: @escaping(Result<RES, Error>) -> Void) {
        var reqData: Data?
        do {
            reqData = try JSONEncoder().encode(requestData)
        } catch {
            response(.failure(ApiClient2Error.errorEncodingRequest(error.localizedDescription )))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = reqData
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            guard error == nil else {
                response(.failure(error!))
                return
            }
            
            guard let hasData = data else {
                response(.failure(ApiClient2Error.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(RES.self, from: hasData)
                response(.success(decodedResponse))
            } catch {
                response(.failure(error))
            }
            
        }
        task.resume()
    }
    
}


enum ApiClient2Error: Error {
    case errorEncodingRequest(String)
    case noData
    case statusError(Int)
}
