//
//  FeedImageDataLoader.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/21/23.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from path: String, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
