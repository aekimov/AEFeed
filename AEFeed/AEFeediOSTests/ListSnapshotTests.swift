//
//  ListSnapshotTests.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/3/23.
//

import XCTest
import AEFeediOS
@testable import AEFeed

final class FeedSnapshotTests: XCTestCase {

    func test_emptyFeed() {
        let sut = makeSUT()

        sut.display(emptyFeed())
        
        record(snapshot: sut.snapshot(for: .iPhone14()), named: "EMPTY_FEED")
    }
    
    func test_feedWithContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        record(snapshot: sut.snapshot(for: .iPhone14()), named: "FEED_WITH_CONTENT")
    }

    
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let refresh = FeedRefreshViewController(delegate: DelegateStub())
        let controller = ListViewController(refreshController: refresh)
        controller.loadViewIfNeeded()
        return controller
    }

    private struct DelegateStub: FeedRefreshViewControllerDelegate {
        func didRequestFeedRefresh() {}
    }
    
    private func emptyFeed() -> [FeedImageCellController] {
        return []
    }
    
    private func feedWithContent() -> [ImageStub] {
        return [ImageStub(title: "Titanic",
                          overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic, 84 years later. A young Rose boards the ship with her mother and fiancé. Meanwhile, Jack Dawson and Fabrizio De Rossi win third-class tickets aboard the ship. Rose tells the whole story from Titanic's departure through to its death—on its first and last voyage—on April 15, 1912.",
                          image: UIImage.make(withColor: .red)),
                ImageStub(title: "The Fabelmans",
                          overview: "Growing up in post-World War II era Arizona, young Sammy Fabelman aspires to become a filmmaker as he reaches adolescence, but soon discovers a shattering family secret and explores how the power of films can help him see the truth.",
                          image: UIImage.make(withColor: .green))]
    }

    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }

        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
        
        do {
            try FileManager.default.createDirectory(at: snapshotURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try snapshotData.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

}

extension UIViewController {
    func snapshot(for configuration: SnapshotConfiguration) -> UIImage {
        return SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    
    static func iPhone14() -> SnapshotConfiguration {
        return SnapshotConfiguration(size: CGSize(width: 390, height: 844))
    }
}

private final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone14()
    
    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        self.rootViewController = root
        self.isHidden = false
    }
    
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}

private extension ListViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [FeedImageCellController] = stubs.map { stub in
            let cellController = FeedImageCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }

        display(cells)
    }
}

private class ImageStub: FeedImageCellControllerDelegate {
    let viewModel: FeedImageViewModel<UIImage>
    weak var controller: FeedImageCellController?

    init(title: String, overview: String, image: UIImage?) {
        viewModel = FeedImageViewModel(title: title, overview: overview, image: image, isLoading: false, shouldRetry: image == nil)
    }

    func didRequestImage() {
        controller?.display(viewModel)
    }

    func didCancelImageRequest() {}
}

