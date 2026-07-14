//
//  ImageCarouselView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class ImageCarouselView: UIView {

    private var imageNames: [String] = []

    private let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
    }

    private let pageLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 13)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private let nextButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        $0.layer.cornerRadius = 18
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = UIColor(named: "1A1C1E")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        clipsToBounds = true
        scrollView.delegate = self

        [scrollView, pageLabel, nextButton].forEach { addSubview($0) }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }
        pageLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.greaterThanOrEqualTo(36)
            make.height.equalTo(22)
        }

        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }

    func configure(imageNames: [String]) {
        self.imageNames = imageNames
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        for (index, name) in imageNames.enumerated() {
            let imageView = UIImageView(image: UIImage(named: name)).then {
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.backgroundColor = UIColor(named: "E8E8E8")
            }
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(self)
                make.leading.equalToSuperview().offset(CGFloat(index) * UIScreen.main.bounds.width)
            }
        }

        layoutIfNeeded()
        scrollView.contentSize = CGSize(width: bounds.width * CGFloat(imageNames.count), height: bounds.height)
        updatePageLabel(page: 0)
        nextButton.isHidden = imageNames.count <= 1
    }

    private func updatePageLabel(page: Int) {
        pageLabel.text = "\(page + 1)/\(imageNames.count)"
    }

    @objc private func nextTapped() {
        let currentPage = Int(round(scrollView.contentOffset.x / max(scrollView.bounds.width, 1)))
        let nextPage = min(currentPage + 1, imageNames.count - 1)
        scrollView.setContentOffset(CGPoint(x: CGFloat(nextPage) * scrollView.bounds.width, y: 0), animated: true)
    }
}

extension ImageCarouselView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        updatePageLabel(page: max(0, min(page, imageNames.count - 1)))
    }
}
