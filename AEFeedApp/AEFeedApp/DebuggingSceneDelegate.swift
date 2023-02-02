//
//  DebuggingSceneDelegate.swift
//  AEFeedApp
//
//  Created by Artem Ekimov on 2/2/23.
//

#if DEBUG
import UIKit
import AEFeed

class DebuggingSceneDelegate: SceneDelegate {
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: localStoreURL)
        }
        
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }

    override func makeRemoteClient() -> HTTPClient {
        if let connectivity = UserDefaults.standard.string(forKey: "connectivity") {
            return DebuggingHTTPClient(connectivity: connectivity)
        }
        
        return super.makeRemoteClient()
    }

}

private class DebuggingHTTPClient: HTTPClient {
    private let connectivity: String
    
    init(connectivity: String) {
        self.connectivity = connectivity
    }
    
    private class Task: HTTPClientTask {
        func cancel() {}
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        switch connectivity {
        case "online":
            completion(.success(makeSuccessfulResponse(for: url)))
        default:
            completion(.failure(NSError(domain: "offline", code: 0)))
        }
        return Task()
    }
    
    private func makeSuccessfulResponse(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    private func makeData(for url: URL) -> Data {
        if url.lastPathComponent == "imagePath" {
            return makeImageData()
        } else {
            return makeFeedData()
        }
    }

    private func makeImageData() -> Data {
        return UIImage.make(withColor: .green).pngData()!
    }

    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["results": [
            ["id": UUID().hashValue,
             "title": "any title",
             "poster_path": "imagePath",
             "overview": "any overview"],
            ["id": UUID().hashValue,
             "title": "any title",
             "poster_path": "imagePath",
             "overview": "any overview"]
        ]])
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }
}

#endif
