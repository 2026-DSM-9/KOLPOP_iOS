//
//  SearchViewController.swift
//  KOLPOP_iOS
//

import UIKit
import MapKit
import SnapKit
import Then

final class SearchViewController: UIViewController {

    private let listingService = ListingService()
    private var mapListings: [MapListing] = []
    private var nearbyListings: [ListingSummary] = []
    private var addressSuggestions: [ListingAddressSuggestionResponse] = []
    private var selectedListingID: String?
    private var mapFetchDebounceTimer: Timer?
    private var suggestionDebounceTimer: Timer?
    private var hasAppearedBefore = false

    private let initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 36.3504, longitude: 127.3845),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

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
        $0.rowHeight = 44
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
    }

    private let suggestionRowHeight: CGFloat = 44
    private let maxVisibleSuggestionRows: CGFloat = 3.5

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
        $0.register(ListingSummaryCell.self, forCellReuseIdentifier: ListingSummaryCell.reuseIdentifier)
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

        mapView.setRegion(initialRegion, animated: false)

        fetchMapListings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard hasAppearedBefore else {
            hasAppearedBefore = true
            return
        }
        resetToDefaultState()
    }

    private func resetToDefaultState() {
        mapFetchDebounceTimer?.invalidate()
        suggestionDebounceTimer?.invalidate()
        addressSuggestions = []
        searchFieldView.textField.text = nil
        searchFieldView.textField.resignFirstResponder()
        suggestionTableView.isHidden = true
        suggestionTableView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        selectedListingID = nil
        mapView.setRegion(initialRegion, animated: false)
        fetchMapListings()
    }

    private func setupLayout() {
        mapContainerView.addSubview(mapView)
        resultHeaderView.addSubview(resultIconImageView)
        resultHeaderView.addSubview(resultCountLabel)

        [titleLabel, searchFieldView, mapContainerView, resultHeaderView, tableView, emptyLabel, suggestionTableView].forEach {
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
        let keyword = searchFieldView.textField.text ?? ""

        suggestionDebounceTimer?.invalidate()
        if keyword.isEmpty {
            addressSuggestions = []
            updateSuggestionTable()
        } else {
            suggestionDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                self?.fetchAddressSuggestions(keyword: keyword)
            }
        }

        mapFetchDebounceTimer?.invalidate()
        mapFetchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            self?.fetchMapListings()
        }
    }

    private func fetchAddressSuggestions(keyword: String) {
        listingService.fetchAddressSuggestions(keyword: keyword, limit: 5) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let suggestions):
                    self.addressSuggestions = suggestions
                case .failure(let error):
                    print("주소 추천 검색 실패: \(error)")
                    self.addressSuggestions = []
                }
                self.updateSuggestionTable()
            }
        }
    }

    private func updateSuggestionTable() {
        let hasSuggestions = !addressSuggestions.isEmpty
        let maxHeight = suggestionRowHeight * maxVisibleSuggestionRows
        let contentHeight = CGFloat(addressSuggestions.count) * suggestionRowHeight

        suggestionTableView.isHidden = !hasSuggestions
        suggestionTableView.isScrollEnabled = contentHeight > maxHeight
        suggestionTableView.snp.updateConstraints { make in
            make.height.equalTo(hasSuggestions ? min(contentHeight, maxHeight) : 0)
        }
        suggestionTableView.reloadData()
    }

    private func fetchMapListings(autoSelectFirstResult: Bool = false) {
        let region = mapView.region
        let minLat = region.center.latitude - region.span.latitudeDelta / 2
        let maxLat = region.center.latitude + region.span.latitudeDelta / 2
        let minLon = region.center.longitude - region.span.longitudeDelta / 2
        let maxLon = region.center.longitude + region.span.longitudeDelta / 2
        let keyword = searchFieldView.textField.text

        listingService.fetchDiscovery(minLatitude: minLat, maxLatitude: maxLat, minLongitude: minLon, maxLongitude: maxLon, keyword: keyword) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let discovery):
                    self.mapListings = discovery.map.listings.map(MapListing.init(response:))
                    self.nearbyListings = discovery.nearbyListings.listings.map(ListingSummary.init(response:))
                case .failure(let error):
                    print("지도 매물 조회 실패: \(error)")
                    self.mapListings = []
                    self.nearbyListings = []
                }

                if let selectedListingID = self.selectedListingID, !self.nearbyListings.contains(where: { $0.id == selectedListingID }) {
                    self.selectedListingID = nil
                }
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(self.mapListings.map { ListingAnnotation(listing: $0) })

                self.resultCountLabel.text = "검색 결과 \(self.nearbyListings.count)"
                self.emptyLabel.isHidden = !self.nearbyListings.isEmpty
                self.tableView.isHidden = self.nearbyListings.isEmpty
                self.tableView.reloadData()

                if autoSelectFirstResult, let firstListing = self.nearbyListings.first {
                    self.selectListing(id: firstListing.id)
                }
            }
        }
    }

    private func startChat(with listing: ListingSummary) {
        // TODO: 실제 채팅방 생성/조회 API 연동 전까지는 매물 정보로 새 ChatRoom을 구성한다. landlordId가 이 응답에 없어 실제 방 생성은 아직 불가능하다.
        let room = ChatRoom(
            id: listing.id,
            imageURL: listing.imageURL,
            title: listing.title,
            lastMessage: "",
            senderName: "",
            status: .inProgress,
            unreadCount: 0
        )
        navigationController?.pushViewController(ChatDetailViewController(room: room), animated: true)
    }

    private func selectListing(id: String) {
        let previousID = selectedListingID
        selectedListingID = id

        var rowsToReload: [IndexPath] = []
        if let previousID, previousID != id, let previousRow = nearbyListings.firstIndex(where: { $0.id == previousID }) {
            rowsToReload.append(IndexPath(row: previousRow, section: 0))
        }
        if let newRow = nearbyListings.firstIndex(where: { $0.id == id }) {
            rowsToReload.append(IndexPath(row: newRow, section: 0))
        }

        tableView.performBatchUpdates {
            tableView.reloadRows(at: rowsToReload, with: .automatic)
        } completion: { [weak self] _ in
            guard let self, let row = self.nearbyListings.firstIndex(where: { $0.id == id }) else { return }
            self.tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .middle, animated: true)
        }

        for case let annotation as ListingAnnotation in mapView.annotations {
            let view = mapView.view(for: annotation) as? PriceAnnotationView
            view?.setHighlighted(annotation.listing.id == id)
        }

        guard let listing = mapListings.first(where: { $0.id == id }) else { return }
        mapView.setCenter(listing.coordinate, animated: true)
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
        mapFetchDebounceTimer?.invalidate()
        mapFetchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            self?.fetchMapListings()
        }
    }
}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView === suggestionTableView ? addressSuggestions.count : nearbyListings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === suggestionTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
            cell.textLabel?.text = addressSuggestions[indexPath.row].fullAddress
            cell.textLabel?.font = .paperlogy(.regular, size: 15)
            cell.selectionStyle = .default
            return cell
        }

        let listing = nearbyListings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ListingSummaryCell.reuseIdentifier, for: indexPath) as! ListingSummaryCell
        cell.configure(with: listing, isSelected: listing.id == selectedListingID)
        cell.onInquireTapped = { [weak self] in
            self?.startChat(with: listing)
        }
        cell.onDetailTapped = { [weak self] in
            guard let listingId = Int(listing.id) else { return }
            self?.navigationController?.pushViewController(ListingDetailViewController(listingId: listingId), animated: true)
        }
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === suggestionTableView {
            // 주소 추천 API는 좌표를 내려주지 않아, 키워드로 다시 조회한 결과 중 첫 번째 매물을 지도/목록에서 선택 상태로 만든다.
            searchFieldView.textField.text = addressSuggestions[indexPath.row].fullAddress
            searchFieldView.textField.resignFirstResponder()
            addressSuggestions = []
            updateSuggestionTable()
            fetchMapListings(autoSelectFirstResult: true)
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)
        selectListing(id: nearbyListings[indexPath.row].id)
    }
}
