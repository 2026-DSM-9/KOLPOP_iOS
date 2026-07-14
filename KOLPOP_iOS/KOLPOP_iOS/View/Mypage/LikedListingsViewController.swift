//
//  LikedListingsViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class LikedListingsViewController: UIViewController {

    // TODO: 실제 찜한 매물 API 연동 전까지는 목업 데이터를 사용한다.
    private let listings: [ListingSummary] = (0..<6).map { index in
        ListingSummary(
            id: "\(index)",
            imageURL: nil,
            title: "대덕소프트웨어마이스터고",
            address: "대전광역시 가정북로 72",
            sizeInfo: "200평 / 1층",
            category: "카페",
            price: "일/ 800,000원",
            likeCount: 486
        )
    }

    private var selectedListingID: String?

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

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension LikedListingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = listings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ListingSummaryCell.reuseIdentifier, for: indexPath) as! ListingSummaryCell
        cell.configure(with: listing, isSelected: listing.id == selectedListingID)
        cell.onInquireTapped = { [weak self] in
            // TODO: 실제 채팅방 생성/조회 API 연동 전까지는 매물 정보로 새 ChatRoom을 구성한다.
            let room = ChatRoom(
                id: listing.id,
                imageURL: listing.imageURL,
                title: listing.title,
                lastMessage: "",
                senderName: "김임대",
                status: .inProgress,
                unreadCount: 0
            )
            self?.navigationController?.pushViewController(ChatDetailViewController(room: room), animated: true)
        }
        cell.onDetailTapped = { [weak self] in
            // TODO: 실제 매물 상세 API 연동 전까지는 목업 데이터를 사용한다.
            self?.navigationController?.pushViewController(ListingDetailViewController(info: .mock), animated: true)
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
