//
//  FeedErrorViewModel.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/27/23.
//

public struct FeedErrorViewModel {
    public  let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}
