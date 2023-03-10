//
//  FeedSnapshotTests.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/3/23.
//

import XCTest
import AEFeediOS
@testable import AEFeed

final class FeedSnapshotTests: XCTestCase {
    
    func test_feedWithContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_CONTENT_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraLarge)), named: "FEED_WITH_CONTENT_light_extraExtraLarge")
    }
    
    func test_feedWithFailedImageLoading() {
        let sut = makeSUT()

        sut.display(feedWithFailedImageLoading())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_FAILED_IMAGE_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_FAILED_IMAGE_LOADING_dark")
    }
    
    func test_feedWithLoadMoreIndicator() {
        let sut = makeSUT()

        sut.display(feedWithLoadMoreIndicator())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_LOAD_MORE_INDICATOR_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_LOAD_MORE_INDICATOR_dark")
    }
    
    func test_feedWithLoadMoreError() {
        let sut = makeSUT()

        sut.display(feedWithLoadMoreError())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_LOAD_MORE_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_LOAD_MORE_ERROR_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraLarge)), named: "FEED_WITH_LOAD_MORE_ERROR_extraExtraLarge_light")
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

    
    private func feedWithContent() -> [ImageStub] {
        return [ImageStub(title: "Titanic",
                          overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic, 84 years later. A young Rose boards the ship with her mother and fianc??. Meanwhile, Jack Dawson and Fabrizio De Rossi win third-class tickets aboard the ship. Rose tells the whole story from Titanic's departure through to its death???on its first and last voyage???on April 15, 1912.",
                          image: UIImage.make(withColor: .red)),
                ImageStub(title: "The Fabelmans",
                          overview: "Growing up in post-World War II era Arizona, young Sammy Fabelman aspires to become a filmmaker as he reaches adolescence, but soon discovers a shattering family secret and explores how the power of films can help him see the truth.",
                          image: UIImage.make(withColor: .green))]
    }
    
    private func feedWithFailedImageLoading() -> [ImageStub] {
        return [ImageStub(title: "Titanic",
                          overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic, 84 years later. A young Rose boards the ship with her mother and fianc??. Meanwhile, Jack Dawson and Fabrizio De Rossi win third-class tickets aboard the ship. Rose tells the whole story from Titanic's departure through to its death???on its first and last voyage???on April 15, 1912.",
                          image: nil),
                ImageStub(title: "The Fabelmans",
                          overview: "Growing up in post-World War II era Arizona, young Sammy Fabelman aspires to become a filmmaker as he reaches adolescence, but soon discovers a shattering family secret and explores how the power of films can help him see the truth.",
                          image: nil)]
    }
    
    private func feedWithLoadMoreIndicator() -> [CellController] {
        let loadMoreController = LoadMoreCellController(callback: {})
        loadMoreController.display(ResourceLoadingViewModel(isLoading: true))
        return [CellController(id: UUID(), cellWithContent()), CellController(id: UUID(), loadMoreController)]
        
    }
    
    private func feedWithLoadMoreError() -> [CellController] {
        let loadMoreController = LoadMoreCellController(callback: {})
        loadMoreController.display(ResourceErrorViewModel(message: "Error message\nCouldn't load"))
        return [CellController(id: UUID(), cellWithContent()), CellController(id: UUID(), loadMoreController)]
    }
    
    private func cellWithContent() -> FeedImageCellController {
        let stub = feedWithContent().first!
        let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, selection: {})
        stub.controller = cellController
        return cellController
    }

}


class ImageStub: FeedImageCellControllerDelegate {
    let viewModel: FeedImageViewModel
    let image: UIImage?
    weak var controller: FeedImageCellController?

    init(title: String, overview: String, image: UIImage?) {
        self.viewModel = FeedImageViewModel(title: title, overview: overview)
        self.image = image
    }

    func didRequestImage() {
        controller?.display(ResourceLoadingViewModel(isLoading: false))
        if let image = image {
            controller?.display(image)
            controller?.display(ResourceErrorViewModel(message: nil))
        } else {
            controller?.display(ResourceErrorViewModel(message: "error"))
        }
    }

    func didCancelImageRequest() {}
}


extension ListViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [CellController] = stubs.map { stub in
            let cellController = FeedImageCellController(viewModel: stub.viewModel, delegate: stub, selection: {})
            stub.controller = cellController
            return CellController(id: UUID(), cellController)
        }

        display(cells)
    }
}
