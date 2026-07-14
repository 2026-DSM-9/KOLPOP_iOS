//
//  SearchViewController.swift
//  KOLPOP_iOS
//

import UIKit
import MapKit
import SnapKit
import Then

final class SearchViewController: UIViewController {

    // TODO: 실제 주소 검색은 주소 API 연동 후 대체. 지금은 목업 자동완성 데이터를 사용한다.
    private let mockSuggestions = [
        "대전광역시 어쩌구",
        "대전광역시 어쩌구 저쩌구",
        "대전광역시 어쩌구 저쩌구 어쩌구",
        "대전광역시 어쩌구 저쩌구",
        "대전광역시 어쩌구 저쩌구 어쩌구"
    ]

    private let categories = ["카페", "리테일", "F&B", "브랜드 팝업"]

    private lazy var listings: [MapListing] = (0..<10).map { index in
        let latOffset = Double.random(in: -0.015...0.015)
        let lonOffset = Double.random(in: -0.015...0.015)
        return MapListing(
            id: "\(index)",
            coordinate: CLLocationCoordinate2D(latitude: 36.3504 + latOffset, longitude: 127.3845 + lonOffset),
            title: "대덕소프트웨어마이스터고",
            address: "대전광역시 가정북로 72",
            sizeInfo: "200평 / 1층",
            category: categories[index % categories.count],
            price: "주 80만원",
            priceBadge: "80만/12만",
            statusText: "모집중",
            imageURL: nil,
            likeCount: 486
        )
    }

    private var visibleListings: [MapListing] = []
    private var selectedListingID: String?

    private let titleLabel = UILabel().then {
        $0.text = "지도 검색"
        $0.font = .paperlogy(.semiBold, size: 24)
        $0.textColor = UIColor(named: "0F1010")
    }

    private let searchFieldView = SearchFieldView().then {
        $0.setPlaceholder("지역 / 주소 입력")
    }

    private let suggestionTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.isHidden = true
        $0.isScrollEnabled = false
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
    }

    private let mapContainerView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
        $0.clipsToBounds = true
    }

    private let mapView = MKMapView().then {
        $0.register(PriceAnnotationView.self, forAnnotationViewWithReuseIdentifier: PriceAnnotationView.reuseIdentifier)
    }

    private let resultHeaderView = UIView()

    private let resultIconImageView = UIImageView(image: UIImage(systemName: "building.2.fill")).then {
        $0.tintColor = UIColor(named: "00AEEF")
        $0.contentMode = .scaleAspectFit
    }

    private let resultCountLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 17)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다"
        $0.font = .paperlogy(.medium, size: 15)
        $0.textColor = UIColor(named: "A3A4A5")
        $0.textAlignment = .center
        $0.isHidden = true
    }

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 130
        $0.register(MapListingCell.self, forCellReuseIdentifier: MapListingCell.reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupLayout()

        searchFieldView.textField.delegate = self
        searchFieldView.textField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        suggestionTableView.dataSource = self
        suggestionTableView.delegate = self
        mapView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 36.3504, longitude: 127.3845),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        mapView.setRegion(initialRegion, animated: false)
        mapView.addAnnotations(listings.map { ListingAnnotation(listing: $0) })

        updateVisibleListings()
    }

    private func setupLayout() {
        mapContainerView.addSubview(mapView)
        resultHeaderView.addSubview(resultIconImageView)
        resultHeaderView.addSubview(resultCountLabel)

        [titleLabel, searchFieldView, suggestionTableView, mapContainerView, resultHeaderView, tableView, emptyLabel].forEach {
            view.addSubview($0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
        searchFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        suggestionTableView.snp.makeConstraints { make in
            make.top.equalTo(searchFieldView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(0)
        }
        mapContainerView.snp.makeConstraints { make in
            make.top.equalTo(searchFieldView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(260)
        }
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        resultHeaderView.snp.makeConstraints { make in
            make.top.equalTo(mapContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        resultIconImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
        resultCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(resultIconImageView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(resultHeaderView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(resultHeaderView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func searchTextChanged() {
        let hasText = !(searchFieldView.textField.text ?? "").isEmpty
        suggestionTableView.isHidden = !hasText
        suggestionTableView.snp.updateConstraints { make in
            make.height.equalTo(hasText ? mockSuggestions.count * 44 : 0)
        }
        suggestionTableView.reloadData()
    }

    private func updateVisibleListings() {
        let region = mapView.region
        let minLat = region.center.latitude - region.span.latitudeDelta / 2
        let maxLat = region.center.latitude + region.span.latitudeDelta / 2
        let minLon = region.center.longitude - region.span.longitudeDelta / 2
        let maxLon = region.center.longitude + region.span.longitudeDelta / 2

        visibleListings = listings.filter {
            $0.coordinate.latitude >= minLat && $0.coordinate.latitude <= maxLat &&
            $0.coordinate.longitude >= minLon && $0.coordinate.longitude <= maxLon
        }

        resultCountLabel.text = "검색 결과 \(visibleListings.count)"
        emptyLabel.isHidden = !visibleListings.isEmpty
        tableView.isHidden = visibleListings.isEmpty
        tableView.reloadData()
    }

    private func selectListing(id: String) {
        selectedListingID = id
        tableView.reloadData()

        guard let listing = listings.first(where: { $0.id == id }) else { return }
        mapView.setCenter(listing.coordinate, animated: true)

        for case let annotation as ListingAnnotation in mapView.annotations {
            let view = mapView.view(for: annotation) as? PriceAnnotationView
            view?.setHighlighted(annotation.listing.id == id)
        }

        if let row = visibleListings.firstIndex(where: { $0.id == id }) {
            tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .middle, animated: true)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is ListingAnnotation else { return nil }
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: PriceAnnotationView.reuseIdentifier, for: annotation)
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let listingAnnotation = view.annotation as? ListingAnnotation else { return }
        selectListing(id: listingAnnotation.listing.id)
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateVisibleListings()
    }
}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView === suggestionTableView ? mockSuggestions.count : visibleListings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === suggestionTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
            cell.textLabel?.text = mockSuggestions[indexPath.row]
            cell.textLabel?.font = .paperlogy(.regular, size: 15)
            cell.selectionStyle = .default
            return cell
        }

        let listing = visibleListings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MapListingCell.reuseIdentifier, for: indexPath) as! MapListingCell
        cell.configure(with: listing, isSelected: listing.id == selectedListingID)
        cell.onInquireTapped = {
            // TODO: 실제 문의하기 플로우 연동
        }
        cell.onDetailTapped = {
            // TODO: 매물 상세 화면 연동
        }
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === suggestionTableView {
            // TODO: 실제 주소 API로 좌표 조회 후 지도 이동
            searchFieldView.textField.text = mockSuggestions[indexPath.row]
            searchFieldView.textField.resignFirstResponder()
            searchTextChanged()
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)
        selectListing(id: visibleListings[indexPath.row].id)
    }
}
