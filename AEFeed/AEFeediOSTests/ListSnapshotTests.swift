//
//  ListSnapshotTests.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/3/23.
//

import XCTest
import AEFeediOS

final class FeedSnapshotTests: XCTestCase {

    func test_emptyFeed() {
        let sut = makeSUT()

        sut.display(emptyFeed())
        
        record(snapshot: sut.snapshot(for: .iPhone14()), named: "EMPTY_FEED")
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
