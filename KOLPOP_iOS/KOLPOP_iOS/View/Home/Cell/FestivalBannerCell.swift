//
//  FestivalBannerCell.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then
import NukeExtensions

final class FestivalBannerCell: UICollectionViewCell {

    static let reuseIdentifier = "FestivalBannerCell"

    private let backgroundImageView = UIImageView().then {
            $0.image = UIImage(named: "Festival")
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = UIColor(named: "0F1010")
    }

    private let dimOverlay = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }

    private let badgeView = UIView().then {
        $0.backgroundColor = UIColor(named: "EA8C21")
        $0.layer.cornerRadius = 14
    }

    private let badgeLabel = UILabel().then {
        $0.text = "📅  다가오는 지역축제"
        $0.font = .systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .white
    }

    private let titleLabel = UILabel().then {
        $0.text = "축제 근처에 팝업을 열어볼까요?"
        $0.font = .systemFont(ofSize: 21, weight: .bold)
        $0.textColor = .white
        $0.numberOfLines = 2
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "축제 인근 빈 건물 구경가기"
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor.white.withAlphaComponent(0.85)
    }

    private let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.right")).then {
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true

        contentView.addSubview(backgroundImageView)
        contentView.addSubview(dimOverlay)
        badgeView.addSubview(badgeLabel)
        contentView.addSubview(badgeView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)

        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        dimOverlay.snp.makeConstraints { $0.edges.equalToSuperview() }

        badgeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        badgeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        }

        arrowImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-6)
        }
    }

    func configure(imageURL: URL?) {
        guard let imageURL else { return }
        NukeExtensions.loadImage(with: imageURL, into: backgroundImageView)
    }
}
