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

    /// 각 페이지의 leading을 이전 페이지의 trailing에 이어 붙이고, 마지막 페이지의 trailing을
    /// scrollView에 고정해 contentSize를 오토레이아웃이 스스로 계산하도록 한다.
    /// 이전에는 leading 오프셋을 UIScreen.main.bounds.width(고정값)로 계산하면서
    /// 너비는 self(가변값)에 맞추다 보니 둘이 미세하게 어긋나 스와이프 시 이미지가 밀리는
    /// 문제가 있었다.
    private func layoutPages(count: Int, configureImageView: (UIImageView, Int) -> Void) {
        pageCount = count
        scrollView.subviews.forEach { $0.removeFromSuperview() }

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
                make.top.bottom.equalToSuperview()
                make.width.equalTo(self)
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
