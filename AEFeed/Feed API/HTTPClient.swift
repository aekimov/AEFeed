//
//  HTTPClient.swift
//  AEFeed
//
//  Created by Artem Ekimov on 10/30/22.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
