//
//  MovieReviewCell.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 2/10/23.
//

import Foundation
import UIKit

public final class MovieReviewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    public required init?(coder: NSCoder) {
        return nil
    }

    private(set) public var authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .label
        label.font = .setFont(forTextStyle: .title3, weight: .medium)
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private(set) public var contentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.font = .setFont(forTextStyle: .body, weight: .regular)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) public var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.font = .setFont(forTextStyle: .footnote, weight: .regular)
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var topSV = UIStackView(axis: .horizontal, distribution: .equalSpacing, alignment: .center, subviews: [authorLabel, dateLabel])
    
    private lazy var mainSV = UIStackView(axis: .vertical, subviews: [topSV, contentLabel])

    private func configureUI() {
        contentView.addSubview(mainSV)
        mainSV.setCustomSpacing(8, after: topSV)
        
        dateLabel.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        authorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        authorLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: mainSV.trailingAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: mainSV.bottomAnchor, constant: 12)
        ])
    }
}
