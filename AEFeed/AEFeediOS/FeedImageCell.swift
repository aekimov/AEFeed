//
//  FeedImageCell.swift
//  AEFeediOS
//
//  Created by Artem Ekimov on 1/20/23.
//

import UIKit

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
    
    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        button.setTitle("↺", for: .normal)
        button.setTitleColor(.tertiaryLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold)
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private(set) public lazy var imageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    var onRetry: (() -> Void)?
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
    
    private func configureUI() {
        let container = UIStackView(axis: .vertical, spacing: 8, subviews: [imageViewContainer, titleLabel, overviewLabel])
        imageViewContainer.addSubview(feedImageRetryButton)
        imageViewContainer.addSubview(feedImageView)
        container.setCustomSpacing(24, after: imageViewContainer)
        contentView.addSubview(container)
        
        let bottomAnchorConstraint = contentView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 16)
        bottomAnchorConstraint.priority = .defaultLow - 1
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 24),
            bottomAnchorConstraint,
            
            feedImageView.heightAnchor.constraint(equalToConstant: 300),
            imageViewContainer.widthAnchor.constraint(equalTo: container.widthAnchor),

            feedImageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor),
            feedImageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor),
            imageViewContainer.bottomAnchor.constraint(equalTo: feedImageView.bottomAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: feedImageView.trailingAnchor),
            
            feedImageRetryButton.topAnchor.constraint(equalTo: imageViewContainer.topAnchor),
            feedImageRetryButton.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor),
            imageViewContainer.bottomAnchor.constraint(equalTo: feedImageRetryButton.bottomAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: feedImageRetryButton.trailingAnchor)
        ])
    }
}
