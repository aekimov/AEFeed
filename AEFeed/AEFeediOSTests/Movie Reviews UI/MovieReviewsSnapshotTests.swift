//
//  MovieReviewsSnapshotTests.swift
//  AEFeediOSTests
//
//  Created by Artem Ekimov on 2/10/23.
//

import XCTest
import AEFeediOS
@testable import AEFeed

final class MovieReviewsSnapshotTests: XCTestCase {
    
    func test_listWithReviews() {
        let sut = makeSUT()

        sut.display(reviews())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "MOVIE_REVIEWS_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "MOVIE_REVIEWS_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraLarge)), named: "MOVIE_REVIEWS_light_extraExtraLarge")
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

    private func reviews() -> [CellController] {
        return reviewControllers().map { CellController($0) }
    }
    
    private func reviewControllers() -> [MovieReviewCellController] {
        return [
            MovieReviewCellController(
                model: MovieReviewViewModel(
                    author: "Cat Ellington",
                    content: "Well, it actually has a title, what the Darth Vader theme. And that title is \"The Imperial March\", composed by the great John Williams, whom, as many of you may already know, also composed the theme music for \"Jaws\" - that legendary score simply titled, \"Main Title (Theme From Jaws)\". Now, with that lil' bit of trivia aside, let us procede with the fabled film currently under review: Star Wars. It had been at a drive-in theater in some small Illinois town or other where my mother, my older brother, and I had spent our weekly \"Movie Date Night\" watching this George Lucas directed cult masterpiece from our car in the parking lot. On the huge outdoor screen, the film appeared to be a silent one, but thanks to an old wire-attached speaker, we were able to hear both the character dialogue and soundtrack loud and clear. We even had ourselves a carful of vittles and snacks - walked back to our vehicle, of course, from the wide-opened cinema's briefly distant concession stand. Indeed, it had been a lovely summer evening that July. I trust that you'll too discover yourself to be a lifelong cult fan in the wake. 😊",
                    date: "2 years ago")),
                
            MovieReviewCellController(
                model: MovieReviewViewModel(
                    author: "MovieGuys",
                    content: "Well, it actually has a title, what the Darth Vader theme. And that title is The Imperial March, composed by the great John Williams, whom, as many of you may already know, also composed the theme music for Jaws - that legendary score simply titled, Main Title (Theme From Jaws)",
                    date: "25 days ago")),
            
            MovieReviewCellController(
                model: MovieReviewViewModel(
                    author: "MSB with a really really really long name",
                    content: "Great movie",
                    date: "1 hour ago"))
        ]
    }

}
