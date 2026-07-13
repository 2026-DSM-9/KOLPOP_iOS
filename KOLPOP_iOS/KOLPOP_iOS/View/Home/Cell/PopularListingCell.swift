//
//  PopularListingCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then
import NukeExtensions

final class PopularListingCell: UICollectionViewCell {

    static let reuseIdentifier = "PopularListingCell"

    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
        $0.clipsToBounds = true
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(named: "E8E8E8")
    }

    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(.semiBold, size: 16)
        $0.textColor = UIColor(named: "0F1010")
        $0.numberOfLines = 1
    }

    private let addressLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 13)
        $0.textColor = UIColor(named: "A3A4A5")
        $0.numberOfLines = 1
    }

    private let sizeLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 12)
        $0.textColor = UIColor(named: "A3A4A5")
    }

    private let priceLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 16)
        $0.textColor = UIColor(named: "00AEEF")
    }

    private let likeIcon = UIImageView(image: UIImage(systemName: "heart")).then {
        $0.tintColor = UIColor(named: "A3A4A5")
        $0.contentMode = .scaleAspectFit
    }

    private let likeLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 13)
        $0.textColor = UIColor(named: "A3A4A5")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(containerView)
        [thumbnailImageView, titleLabel, addressLabel, sizeLabel, priceLabel, likeIcon, likeLabel].forEach {
            containerView.addSubview($0)
        }

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(0.8)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        sizeLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().inset(12)
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(sizeLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }

        likeLabel.snp.makeConstraints {
            $0.centerY.equalTo(priceLabel)
            $0.trailing.equalToSuperview().inset(12)
        }
        likeIcon.snp.makeConstraints {
            $0.centerY.equalTo(priceLabel)
            $0.trailing.equalTo(likeLabel.snp.leading).offset(-4)
            $0.width.height.equalTo(16)
        }
    }

    func configure(with listing: PopularListing) {
        if let imageURL = listing.imageURL {
            NukeExtensions.loadImage(with: imageURL, into: thumbnailImageView)
        } else {
            thumbnailImageView.image = nil
        }
        titleLabel.text = listing.title
        addressLabel.text = listing.address
        sizeLabel.text = listing.sizeInfo
        priceLabel.text = listing.price
        likeLabel.text = "\(listing.likeCount)"
    }
}
