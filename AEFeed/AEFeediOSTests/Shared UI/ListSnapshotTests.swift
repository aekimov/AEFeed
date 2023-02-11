//
//  ListSnapshotTests.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/10/23.
//

import XCTest
import AEFeediOS
@testable import AEFeed

final class ListSnapshotTests: XCTestCase {

    func test_emptyList() {
        let sut = makeSUT()

        sut.display(emptyList())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_LIST_dark")
    }

    func test_listWithErrorMessage() {
        let sut = makeSUT()

        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraLarge)), named: "LIST_WITH_ERROR_MESSAGE_light_extraExtraLarge")
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let refresh = RefreshViewController(onRefresh: {})
        let controller = ListViewController(refreshController: refresh)
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyList() -> [CellController] {
        return []
    }
}
