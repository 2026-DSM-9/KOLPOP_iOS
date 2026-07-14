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

    private let chatService = ChatService()
    private var rooms: [ChatRoom] = []
    private var filteredRooms: [ChatRoom] = []
    private let loadingOverlayView = LoadingOverlayView(message: "채팅 목록을 불러오는 중이에요")
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
        fetchRooms()
    }

    private func fetchRooms() {
        chatService.fetchRooms { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.loadingOverlayView.isHidden = true
                switch result {
                case .success(let responses):
                    self.rooms = responses.map(ChatRoom.init(response:))
                    self.applyFilter()
                case .failure(let error):
                    print("채팅방 목록 조회 실패: \(error)")
                }
            }
        }
    }

    private func setupLayout() {
        [titleLabel, filterCollectionView, tableView, loadingOverlayView].forEach { view.addSubview($0) }

        loadingOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
