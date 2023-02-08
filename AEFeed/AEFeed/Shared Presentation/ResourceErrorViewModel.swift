//
//  ResourceErrorViewModel.swift
//  AEFeed
//
//  Created by Artem Ekimov on 1/27/23.
//

public struct ResourceErrorViewModel {
    public  let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
