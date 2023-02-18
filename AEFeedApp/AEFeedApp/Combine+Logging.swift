//
//  Combine+Logging.swift
//  AEFeedApp
//
//  Created by Artem Ekimov on 2/18/23.
//

import Combine
import Foundation
import UIKit
import os

extension Publisher {
    func logElapsedTime(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        var startTime = CACurrentMediaTime()
        
        return handleEvents(
            receiveSubscription: { _ in
                logger.trace("Started loading url: \(url)")
                startTime = CACurrentMediaTime()
            },
            receiveCompletion: { _ in
                let elapsed = CACurrentMediaTime() - startTime
                logger.trace("Finished loading url: \(url) in \(elapsed) seconds")
            }).eraseToAnyPublisher()
    }
    
    func logErrors(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        return handleEvents(
            receiveCompletion: { result in
                if case let .failure(error) = result {
                    logger.trace("Falied to load url: \(url) with error \(error)")
                }
            }).eraseToAnyPublisher()
    }
    
    func logCacheMisses(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        return handleEvents(
            receiveCompletion: { result in
                if case .failure = result {
                    logger.trace("Cache miss url: \(url)")
                }
            }).eraseToAnyPublisher()
    }
    
}

