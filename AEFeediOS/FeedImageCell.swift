//
//  FeedImageCell.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/20/23.
//

import UIKit
import AEFeed

public final class FeedImageCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    public required init?(coder: NSCoder) {
        return nil
    }

    private(set) public var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .label
        label.font = .setFont(forTextStyle: .title3, weight: .bold)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private(set) public var overviewLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.font = .setFont(forTextStyle: .footnote, weight: .regular)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private(set) public var feedImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    private func configureUI() {
        let container = UIStackView(axis: .vertical, spacing: 8, subviews: [feedImageView, titleLabel, overviewLabel])
        container.setCustomSpacing(24, after: feedImageView)
        contentView.addSubview(container)
        
        let bottomAnchorConstraint = contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 16)
        bottomAnchorConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 24),
            feedImageView.widthAnchor.constraint(equalTo: container.widthAnchor),
            feedImageView.heightAnchor.constraint(equalTo: container.widthAnchor),
            bottomAnchorConstraint
        ])
    }
    
    func configure(_ item: FeedImage) {
        titleLabel.text = item.title
        overviewLabel.text = item.overview
        feedImageView.image = UIImage(named: item.imagePath)
    }
}

public extension UIFont {
    static func setFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}

public extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis = .vertical,
                     distribution: UIStackView.Distribution = .fill,
                     alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat = 0,
                     margins: NSDirectionalEdgeInsets = .zero,
                     subviews: [UIView] = []) {
        
        self.init(arrangedSubviews: subviews)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isLayoutMarginsRelativeArrangement = true
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        self.directionalLayoutMargins = margins
    }
}

