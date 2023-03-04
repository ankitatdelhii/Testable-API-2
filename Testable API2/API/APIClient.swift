//
//  APIClient.swift
//  Testable API2
//
//  Created by Ankit Saxena on 04/03/23.
//

import Foundation

class APIClient {
    
    //MARK: Properties
    let session: URLSession!
    
    //MARK: Lifecycle
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //MARK: Helper
    func post<REQ: Encodable, RES: Decodable>(url: URL, request: REQ, responseType: RES.Type,completion: @escaping (Result<RES, Error>) -> Void ) {
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        var reqData: Data?
        
        do {
            reqData = try JSONEncoder().encode(request)
        } catch {
            completion(.failure(APIClientError.encodingReqError(error.localizedDescription)))
            return
        }
        
        urlReq.httpBody = reqData
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlReq) { data, urlRes, error in
            
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let hasResponse = urlRes as? HTTPURLResponse else {
                completion(.failure(APIClientError.noResponse))
                return
            }
            
            switch hasResponse.statusCode {
                
            case 200...299:
                print("Got Res")
                
                guard let hasData = data else {
                    completion(.failure(APIClientError.noData))
                    return
                }
                
                do {
                    let decodedRes = try JSONDecoder().decode(RES.self, from: hasData)
                    completion(.success(decodedRes))
                } catch {
                    
                }
                
                
            default:
                print("Invalid Response")
                completion(.failure(APIClientError.invalidStatusCode(hasResponse.statusCode)))
            }
            
        }
        
        task.resume()
        
    }
    
}

enum APIClientError: Error {
    case encodingReqError(String)
    case noResponse
    case noData
    case invalidStatusCode(Int)
}
