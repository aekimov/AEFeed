//
//  SceneDelegate.swift
//  AEFeedPrototype
//
//  Created by Artem Ekimov on 1/19/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let items: [FeedImage] = [
            FeedImage(id: 1, title: "Titanic", imagePath: "image0", overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic, 84 years later. A young Rose boards the ship with her mother and fiancé. Meanwhile, Jack Dawson and Fabrizio De Rossi win third-class tickets aboard the ship. Rose tells the whole story from Titanic's departure through to its death—on its first and last voyage—on April 15, 1912."),
            FeedImage(id: 2, title: "The Fabelmans", imagePath: "image1", overview: "Growing up in post-World War II era Arizona, young Sammy Fabelman aspires to become a filmmaker as he reaches adolescence, but soon discovers a shattering family secret and explores how the power of films can help him see the truth."),
            FeedImage(id: 3, title: "Plane", imagePath: "image2", overview: "After a heroic job of successfully landing his storm-damaged aircraft in a war zone, a fearless pilot finds himself between the agendas of multiple militias planning to take the plane and its passengers hostage."),
            FeedImage(id: 4, title: "Black Panther: Wakanda Forever", imagePath: "image3", overview: "Queen Ramonda, Shuri, M’Baku, Okoye and the Dora Milaje fight to protect their nation from intervening world powers in the wake of King T’Challa’s death. As the Wakandans strive to embrace their next chapter, the heroes must band together with the help of War Dog Nakia and Everett Ross and forge a new path for the kingdom of Wakanda."),
            FeedImage(id: 5, title: "Detective Knight: Rogue", imagePath: "image4", overview: "As Los Angeles prepares for Halloween, mask-wearing armed robbers critically wound detective James Knight’s partner in a shootout following a heist. With Knight in hot pursuit, the bandits flee L.A. for New York, where the detective’s dark past collides with his present case and threatens to tear his world apart…unless redemption can claim Knight first.")
        ]
        
        window = UIWindow(windowScene: scene)
        let viewController = TableViewController(items: items)
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }

}

