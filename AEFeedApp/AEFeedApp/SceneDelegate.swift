//
//  SceneDelegate.swift
//  AEFeedApp
//
//  Created by Artem Ekimov on 1/29/23.
//

import UIKit
import AEFeed
import AEFeediOS
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let remoteURL = URL(string: "https://raw.githubusercontent.com/aekimov/TestServerJSON/main/server.json")!

        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)

        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: remoteFeedLoader,
            imageLoader: remoteImageLoader)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = feedViewController
        window?.makeKeyAndVisible()
    }



}

