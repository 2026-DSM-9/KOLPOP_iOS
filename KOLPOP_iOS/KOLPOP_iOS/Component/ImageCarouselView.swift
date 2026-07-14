//
//  ImageCarouselView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then
import NukeExtensions

final class ImageCarouselView: UIView {

    private var pageCount = 0

    private let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false
        $0.isDirectionalLockEnabled = true
    }

    private let pageLabel = UILabel().then {
        $0.font = .paperlogy(.medium, size: 13)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private let previousButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        $0.layer.cornerRadius = 18
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = UIColor(named: "1A1C1E")
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

        [scrollView, pageLabel, previousButton, nextButton].forEach { addSubview($0) }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        previousButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(36)
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

        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }

    func configure(imageNames: [String]) {
        layoutPages(count: imageNames.count) { imageView, index in
            imageView.image = UIImage(named: imageNames[index])
        }
    }

    func configure(imageURLs: [URL]) {
        layoutPages(count: imageURLs.count) { imageView, index in
            NukeExtensions.loadImage(with: imageURLs[index], into: imageView)
        }
    }

    private func layoutPages(count: Int, configureImageView: (UIImageView, Int) -> Void) {
        pageCount = count
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        let pageWidth = bounds.width
        let pageHeight = bounds.height

        var previousImageView: UIImageView?
        for index in 0..<count {
            let imageView = UIImageView().then {
                $0.contentMode = .scaleAspectFit
                $0.clipsToBounds = true
                $0.backgroundColor = UIColor(named: "E8E8E8")
            }
            configureImageView(imageView, index)
            scrollView.addSubview(imageView)

            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.equalTo(pageWidth)
                make.height.equalTo(pageHeight)
                if let previousImageView {
                    make.leading.equalTo(previousImageView.snp.trailing)
                } else {
                    make.leading.equalToSuperview()
                }
                if index == count - 1 {
                    make.trailing.equalToSuperview()
                }
            }
            previousImageView = imageView
        }

        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(count), height: pageHeight)
        updatePage(0)
    }

    private func updatePage(_ page: Int) {
        pageLabel.text = "\(page + 1)/\(pageCount)"
        previousButton.isHidden = pageCount <= 1 || page == 0
        nextButton.isHidden = pageCount <= 1 || page == pageCount - 1
    }

    @objc private func previousTapped() {
        let currentPage = Int(round(scrollView.contentOffset.x / max(scrollView.bounds.width, 1)))
        let previousPage = max(currentPage - 1, 0)
        scrollView.setContentOffset(CGPoint(x: CGFloat(previousPage) * scrollView.bounds.width, y: 0), animated: true)
    }

    @objc private func nextTapped() {
        let currentPage = Int(round(scrollView.contentOffset.x / max(scrollView.bounds.width, 1)))
        let nextPage = min(currentPage + 1, pageCount - 1)
        scrollView.setContentOffset(CGPoint(x: CGFloat(nextPage) * scrollView.bounds.width, y: 0), animated: true)
    }
}

extension ImageCarouselView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > 0 else { return }
        let page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        updatePage(max(0, min(page, pageCount - 1)))
    }
}
