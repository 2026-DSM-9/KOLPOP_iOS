//
//  LikedListingsViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class LikedListingsViewController: UIViewController {

    private let listingService = ListingService()
    private var listings: [ListingSummary] = []
    private var selectedListingID: String?

    private let loadingOverlayView = LoadingOverlayView(message: "찜한 매물을 불러오는 중이에요")

    private let emptyLabel = UILabel().then {
        $0.text = "찜한 매물이 없습니다"
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
        title = "찜한 매물"

        [tableView, emptyLabel, loadingOverlayView].forEach { view.addSubview($0) }
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(120)
        }
        loadingOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.dataSource = self
        tableView.delegate = self

        fetchLikedListings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 마이페이지가 탭 내비게이션 바를 숨겨두기 때문에 이 화면에서는 다시 보여준다.
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func fetchLikedListings() {
        listingService.fetchLikedListings { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.loadingOverlayView.isHidden = true
                switch result {
                case .success(let responses):
                    self.listings = responses.map(ListingSummary.init(response:))
                case .failure(let error):
                    print("찜한 매물 조회 실패: \(error)")
                    self.listings = []
                }
                self.emptyLabel.isHidden = !self.listings.isEmpty
                self.tableView.isHidden = self.listings.isEmpty
                self.tableView.reloadData()
            }
        }
    }
}

extension LikedListingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = listings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ListingSummaryCell.reuseIdentifier, for: indexPath) as! ListingSummaryCell
        cell.configure(with: listing, isSelected: listing.id == selectedListingID, isLiked: true)
        cell.onInquireTapped = { [weak self] in
            // TODO: 실제 채팅방 생성 API 연동 전까지는 매물 정보로 새 ChatRoom을 구성한다. landlordId가 이 응답에 없어 실제 방 생성은 아직 불가능하다.
            let room = ChatRoom(
                id: listing.id,
                imageURL: listing.imageURL,
                title: listing.title,
                lastMessage: "",
                senderName: "",
                status: .inProgress,
                unreadCount: 0
            )
            self?.navigationController?.pushViewController(ChatDetailViewController(room: room), animated: true)
        }
        cell.onDetailTapped = { [weak self] in
            guard let listingId = Int(listing.id) else { return }
            self?.navigationController?.pushViewController(ListingDetailViewController(listingId: listingId), animated: true)
        }
        return cell
    }
}

extension LikedListingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let previousID = selectedListingID
        let tappedID = listings[indexPath.row].id
        selectedListingID = (previousID == tappedID) ? nil : tappedID

        var rowsToReload: [IndexPath] = [indexPath]
        if let previousID, previousID != tappedID, let previousRow = listings.firstIndex(where: { $0.id == previousID }) {
            rowsToReload.append(IndexPath(row: previousRow, section: 0))
        }
        tableView.reloadRows(at: rowsToReload, with: .automatic)
    }
}
