//
//  ListingDetailViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class ListingDetailViewController: UIViewController {

    private let listingService = ListingService()
    private let chatService = ChatService()
    private var info: ListingDetailInfo?
    private let loadingOverlayView = LoadingOverlayView(message: "매물 정보를 불러오는 중이에요")

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()

    private let imageCarouselView = ImageCarouselView()

    private let infoCardView = UIView().then {
        $0.backgroundColor = UIColor(named: "0F1010")
        $0.layer.cornerRadius = 16
    }
    private let addressLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 18)
        $0.textColor = .white
    }
    private let landlordLabel = UILabel().then {
        $0.font = .paperlogy(.regular, size: 15)
        $0.textColor = UIColor.white.withAlphaComponent(0.7)
    }
    private let tagWrapView = ChipWrapView()

    private let priceCard = InfoCardView(iconName: "wonsign.circle.fill", title: "가격 정보", iconTintColorName: "00AEEF")
    private let operationCard = InfoCardView(iconName: "building.2.fill", title: "운영 가능 정보", iconTintColorName: "EA8C21")
    private let facilityCard = InfoCardView(iconName: "desktopcomputer", title: "시설", iconTintColorName: "1A1C1E")
    private let restrictionCard = InfoCardView(iconName: "exclamationmark.triangle.fill", title: "업종 제한", iconTintColorName: "EA8C21")
    private let descriptionCard = InfoCardView(iconName: "doc.text.fill", title: "소개", iconTintColorName: "1A1C1E")

    private let inquireButton = UIButton(type: .system).then {
        $0.setTitle("문의하러 가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .paperlogy(.semiBold, size: 17)
        $0.backgroundColor = UIColor(named: "00AEEF")
        $0.layer.cornerRadius = 16
    }

    // TODO: 실제 찜하기 API 연동 전까지는 화면 안에서만 유지되는 상태로 처리한다.
    private var isLiked = false

    private let likeButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.layer.cornerRadius = 16
    }

    private var listingId: Int?

    init(info: ListingDetailInfo) {
        self.info = info
        super.init(nibName: nil, bundle: nil)
    }

    init(listingId: Int) {
        self.info = nil
        self.listingId = listingId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        updateLikeButton()
        inquireButton.addTarget(self, action: #selector(inquireTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)

        if let info {
            title = info.title
            configure()
        } else if let listingId {
            fetchDetail(listingId: listingId)
        }
    }

    private func fetchDetail(listingId: Int) {
        loadingOverlayView.isHidden = false
        listingService.fetchDetail(listingId: listingId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.loadingOverlayView.isHidden = true
                switch result {
                case .success(let response):
                    let info = ListingDetailInfo(response: response)
                    self.info = info
                    self.title = info.title
                    self.configure()
                case .failure(let error):
                    print("매물 상세 조회 실패: \(error)")
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 지도 검색처럼 내비게이션 바를 숨겨둔 화면에서 진입할 수도 있어 다시 보여준다.
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func likeTapped() {
        isLiked.toggle()
        updateLikeButton()
    }

    private func updateLikeButton() {
        let imageName = isLiked ? "heart.fill" : "heart"
        let tintColorName = isLiked ? "EA8C21" : "A3A4A5"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likeButton.tintColor = UIColor(named: tintColorName)
    }

    @objc private func inquireTapped() {
        guard let info else { return }

        loadingOverlayView.isHidden = false
        chatService.createRoom(landlordId: info.landlordId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.loadingOverlayView.isHidden = true
                switch result {
                case .success(let roomResponse):
                    let room = ChatRoom(response: roomResponse)
                    self.navigationController?.pushViewController(ChatDetailViewController(room: room), animated: true)
                case .failure(let error):
                    print("채팅방 생성 실패: \(error)")
                }
            }
        }
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        view.addSubview(inquireButton)
        view.addSubview(likeButton)
        scrollView.addSubview(contentView)

        infoCardView.addSubview(addressLabel)
        infoCardView.addSubview(landlordLabel)
        infoCardView.addSubview(tagWrapView)

        [imageCarouselView, infoCardView, priceCard, operationCard, facilityCard, restrictionCard, descriptionCard].forEach {
            contentView.addSubview($0)
        }
        view.addSubview(loadingOverlayView)
        loadingOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(inquireButton.snp.top).offset(-12)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        imageCarouselView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        infoCardView.snp.makeConstraints { make in
            make.top.equalTo(imageCarouselView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        landlordLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        tagWrapView.snp.makeConstraints { make in
            make.top.equalTo(landlordLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        priceCard.snp.makeConstraints { make in
            make.top.equalTo(infoCardView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        operationCard.snp.makeConstraints { make in
            make.top.equalTo(priceCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        facilityCard.snp.makeConstraints { make in
            make.top.equalTo(operationCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        restrictionCard.snp.makeConstraints { make in
            make.top.equalTo(facilityCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        descriptionCard.snp.makeConstraints { make in
            make.top.equalTo(restrictionCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.width.height.equalTo(54)
        }
        inquireButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(likeButton.snp.leading).offset(-12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(54)
        }
    }

    private func configure() {
        guard let info else { return }

        if info.imageURLs.isEmpty {
            imageCarouselView.configure(imageNames: info.imageNames)
        } else {
            imageCarouselView.configure(imageURLs: info.imageURLs)
        }
        addressLabel.text = info.address
        landlordLabel.text = info.landlordName
        tagWrapView.setChips(info.tags.map { makeDarkTagView(title: $0) })

        setupPriceCard(info: info)
        setupOperationCard(info: info)
        setupFacilityCard(info: info)
        setupRestrictionCard(info: info)
        setupDescriptionCard(info: info)
    }

    private func setupPriceCard(info: ListingDetailInfo) {
        let depositBox = makeInfoBox(label: "보증금", value: info.deposit, valueColorName: "1A1C1E")
        let dailyPriceBox = makeInfoBox(label: "일당 가격", value: info.dailyPrice, valueColorName: "00688F")
        let areaBox = makeInfoBox(label: "면적", value: info.area, valueColorName: "1A1C1E")

        let topStack = UIStackView(arrangedSubviews: [depositBox, dailyPriceBox]).then {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
        let stack = UIStackView(arrangedSubviews: [topStack, areaBox]).then {
            $0.axis = .vertical
            $0.spacing = 12
        }
        priceCard.contentContainer.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupOperationCard(info: ListingDetailInfo) {
        let stack = UIStackView(arrangedSubviews: [
            makeInfoRow(label: "이용 가능 기간", value: info.availablePeriod),
            makeInfoRow(label: "운영 일수", value: info.operatingDaysInfo)
        ]).then {
            $0.axis = .vertical
            $0.spacing = 12
        }
        operationCard.contentContainer.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupFacilityCard(info: ListingDetailInfo) {
        if info.facilities.isEmpty {
            let emptyLabel = makeEmptyLabel()
            facilityCard.contentContainer.addSubview(emptyLabel)
            emptyLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            let wrapView = ChipWrapView()
            wrapView.setChips(info.facilities.map { makeLightTagView(title: $0) })
            facilityCard.contentContainer.addSubview(wrapView)
            wrapView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    private func setupRestrictionCard(info: ListingDetailInfo) {
        if info.businessRestrictions.isEmpty {
            let emptyLabel = makeEmptyLabel()
            restrictionCard.contentContainer.addSubview(emptyLabel)
            emptyLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            let stack = UIStackView(arrangedSubviews: info.businessRestrictions.map { makeBulletRow(text: $0) }).then {
                $0.axis = .vertical
                $0.spacing = 8
            }
            restrictionCard.contentContainer.addSubview(stack)
            stack.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    private func setupDescriptionCard(info: ListingDetailInfo) {
        let label = UILabel().then {
            $0.text = info.description
            $0.font = .paperlogy(.regular, size: 15)
            $0.textColor = UIColor(named: "1A1C1E")
            $0.numberOfLines = 0
        }
        descriptionCard.contentContainer.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func makeInfoBox(label: String, value: String, valueColorName: String) -> UIView {
        let container = UIView().then {
            $0.backgroundColor = UIColor(named: "F8F8F8")
            $0.layer.cornerRadius = 12
        }
        let labelView = UILabel().then {
            $0.text = label
            $0.font = .paperlogy(.regular, size: 13)
            $0.textColor = UIColor(named: "A3A4A5")
        }
        let valueView = UILabel().then {
            $0.text = value
            $0.font = .paperlogy(.bold, size: 18)
            $0.textColor = UIColor(named: valueColorName)
        }
        container.addSubview(labelView)
        container.addSubview(valueView)
        labelView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(14)
        }
        valueView.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().offset(-14)
        }
        return container
    }

    private func makeInfoRow(label: String, value: String) -> UIView {
        let row = UIView()
        let labelView = UILabel().then {
            $0.text = label
            $0.font = .paperlogy(.regular, size: 14)
            $0.textColor = UIColor(named: "767778")
        }
        let valueView = UILabel().then {
            $0.text = value
            $0.font = .paperlogy(.semiBold, size: 14)
            $0.textColor = UIColor(named: "1A1C1E")
            $0.textAlignment = .right
        }
        row.addSubview(labelView)
        row.addSubview(valueView)
        labelView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        valueView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualTo(labelView.snp.trailing).offset(8)
        }
        return row
    }

    private func makeBulletRow(text: String) -> UIView {
        let row = UIView()
        let dotView = UIView().then {
            $0.backgroundColor = UIColor(named: "EA8C21")
            $0.layer.cornerRadius = 3
        }
        let label = UILabel().then {
            $0.text = text
            $0.font = .paperlogy(.medium, size: 14)
            $0.textColor = UIColor(named: "1A1C1E")
            $0.numberOfLines = 0
        }
        row.addSubview(dotView)
        row.addSubview(label)
        dotView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(label).offset(-1)
            make.width.height.equalTo(6)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(dotView.snp.trailing).offset(10)
            make.trailing.top.bottom.equalToSuperview()
        }
        return row
    }

    private func makeEmptyLabel() -> UILabel {
        UILabel().then {
            $0.text = "없음"
            $0.font = .paperlogy(.regular, size: 14)
            $0.textColor = UIColor(named: "A3A4A5")
        }
    }

    private func makeDarkTagView(title: String) -> UIView {
        let container = UIView().then {
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            $0.layer.cornerRadius = 8
        }
        let label = UILabel().then {
            $0.text = title
            $0.font = .paperlogy(.medium, size: 12)
            $0.textColor = .white
        }
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        }
        return container
    }

    private func makeLightTagView(title: String) -> UIView {
        let container = UIView().then {
            $0.backgroundColor = UIColor(named: "BFEBFB")
            $0.layer.cornerRadius = 8
        }
        let label = UILabel().then {
            $0.text = title
            $0.font = .paperlogy(.medium, size: 13)
            $0.textColor = UIColor(named: "00688F")
        }
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
        return container
    }
}
