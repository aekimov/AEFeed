//
//  ListViewControllerTests.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 1/20/23.
//

import XCTest
import UIKit

class ListViewController: UIViewController {
    private var loader: ListViewControllerTests.LoaderSpy?
    
    convenience init(loader: ListViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load()
    }
}

class ListViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let _ = ListViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = ListViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    
    //MARK: - Helpers
    
    class LoaderSpy {
        var loadCallCount = 0
        
        func load() {
            loadCallCount += 1
        }
    }
    
}
