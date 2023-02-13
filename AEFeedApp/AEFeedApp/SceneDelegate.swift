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
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let localStoreURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("feed-store.sqlite")

    private lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        return try! CoreDataFeedStore(storeURL: localStoreURL)
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    private lazy var navigationConttroller = UINavigationController(rootViewController: FeedUIComposer.feedComposedWith(
        feedLoader: makeRemoteFeedLoaderWithFallback,
        imageLoader: makeLocalImageLoaderWithRemoteFallback,
        selection: showReviews))
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationConttroller
        window?.makeKeyAndVisible()
    }

    private func makeRemoteFeedLoaderWithFallback() -> AnyPublisher<[FeedImage], Error> {
        let remoteURL = URL(string: "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1&api_key=")!
        
        print(remoteURL)
        return httpClient
            .getPublisher(url: remoteURL)
            .tryMap(FeedItemsMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient] in
                httpClient
                    .getPublisher(url: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
            })
    }
    
    private func showReviews(for image: FeedImage) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(image.id)/reviews?language=en-US&page=1&api_key=")!
        let reviewsVC = MovieReviewsUIComposer.reviewsComposedWith(reviewsLoader: makeRemoteCommentsLoader(url: url))
        navigationConttroller.pushViewController(reviewsVC, animated: true)
    }
    
    private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[MovieReview], Error> {
        return { [httpClient] in
            return httpClient
                .getPublisher(url: url)
                .tryMap(MovieReviewsMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }

}
