//
//  ListViewControllerTests+Localization.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 1/22/23.
//

import Foundation
import XCTest
import AEFeediOS

extension ListViewControllerTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: ListViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
