//
//  RemoteFeedItem.swift
//  AEFeed
//
//  Created by Artem Ekimov on 11/4/22.
//

import Foundation

struct RemoteFeed: Decodable {
    let results: [RemoteItem]
    let page: Int
}

struct RemoteItem: Decodable {
    let id: Int
    let title: String
    let poster_path: String?
    let overview: String
}
