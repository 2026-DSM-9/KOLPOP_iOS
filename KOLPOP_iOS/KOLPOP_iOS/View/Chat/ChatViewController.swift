//
//  ChatViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class ChatViewController: UIViewController {

    private enum Filter: Int, CaseIterable {
        case all
        case inProgress
        case completed
        case rejected

        var title: String {
            switch self {
            case .all: return "전체"
            case .inProgress: return "진행중"
            case .completed: return "완료"
            case .rejected: return "거절"
            }
        }

        var status: ChatStatus? {
            switch self {
            case .all: return nil
            case .inProgress: return .inProgress
            case .completed: return .completed
            case .rejected: return .rejected
            }
        }
    }

    // TODO: 실제 채팅 목록 API 연동 전까지는 목업 데이터를 사용한다.
    private let rooms: [ChatRoom] = [
        ChatRoom(id: "0", imageURL: nil, title: "대덕소프트웨어마이스터고", lastMessage: "네, 7월 20일부터 3주간 가능합니다.", senderName: "김임대", status: .inProgress, unreadCount: 0),
        ChatRoom(id: "1", imageURL: nil, title: "대덕소프트웨어마이스터고", lastMessage: "네, 7월 20일부터 3주간 가능합니다.", senderName: "김임대", status: .inProgress, unreadCount: 1),
        ChatRoom(id: "2", imageURL: nil, title: "대덕소프트웨어마이스터고", lastMessage: "네, 7월 20일부터 3주간 가능합니다.", senderName: "김임대", status: .inProgress, unreadCount: 2),
        ChatRoom(id: "3", imageURL: nil, title: "대덕소프트웨어마이스터고", lastMessage: "네, 7월 20일부터 3주간 가능합니다.", senderName: "김임대", status: .completed, unreadCount: 0),
        ChatRoom(id: "4", imageURL: nil, title: "대덕소프트웨어마이스터고", lastMessage: "네, 7월 20일부터 3주간 가능합니다.", senderName: "김임대", status: .rejected, unreadCount: 0),
        ChatRoom(id: "5", imageURL: nil, title: "대덕소프트웨어마이스터고", lastMessage: "네, 7월 20일부터 3주간 가능합니다.", senderName: "김임대", status: .completed, unreadCount: 0)
    ]

    private var filteredRooms: [ChatRoom] = []
    private var selectedFilter: Filter = .all

    private let titleLabel = UILabel().then {
        $0.text = "채팅"
        $0.font = .paperlogy(.semiBold, size: 24)
        $0.textColor = UIColor(named: "0F1010")
    }

    private lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 8
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.register(CategoryChipCell.self, forCellWithReuseIdentifier: CategoryChipCell.reuseIdentifier)
        }
    }()

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 120
        $0.register(ChatRoomCell.self, forCellReuseIdentifier: ChatRoomCell.reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupLayout()

        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        filterCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        applyFilter()
    }

    private func setupLayout() {
        [titleLabel, filterCollectionView, tableView].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func applyFilter() {
        if let status = selectedFilter.status {
            filteredRooms = rooms.filter { $0.status.listBadgeText == status.listBadgeText }
        } else {
            filteredRooms = rooms
        }
        tableView.reloadData()
    }
}

extension ChatViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Filter.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryChipCell.reuseIdentifier, for: indexPath) as! CategoryChipCell
        cell.configure(title: Filter.allCases[indexPath.item].title)
        return cell
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = .paperlogy(.medium, size: 12)
        label.text = Filter.allCases[indexPath.item].title
        let width = label.intrinsicContentSize.width + 40
        return CGSize(width: width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilter = Filter.allCases[indexPath.item]
        applyFilter()
    }
}

extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatRoomCell.reuseIdentifier, for: indexPath) as! ChatRoomCell
        cell.configure(with: filteredRooms[indexPath.row])
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = filteredRooms[indexPath.row]
        navigationController?.pushViewController(ChatDetailViewController(room: room), animated: true)
    }
}
