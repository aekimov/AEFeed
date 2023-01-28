//
//  HTTPURLResponse+StatusCode.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/28/23.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
