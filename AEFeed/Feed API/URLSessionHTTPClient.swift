//
//  URLSessionHTTPClient.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/31/22.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {

    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesError: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesError()))
            }
            
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
