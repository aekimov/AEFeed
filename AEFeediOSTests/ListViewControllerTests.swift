//
//  ListViewControllerTests.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 1/20/23.
//

import XCTest

class ListViewController {
    init(loader: ListViewControllerTests.LoaderSpy) {
        
    }
}

class ListViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let _ = ListViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    class LoaderSpy {
        var loadCallCount = 0
    }
}
