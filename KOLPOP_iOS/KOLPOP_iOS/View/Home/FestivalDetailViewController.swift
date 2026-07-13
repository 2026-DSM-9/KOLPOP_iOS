//
//  FestivalDetailViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class FestivalDetailViewController: UIViewController {

    private let festival: Festival
    private let buildings: [PopularListing]

    private let headerCardView = FestivalInfoCardView(descriptionNumberOfLines: 0)

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 260
        $0.register(BuildingListingCell.self, forCellReuseIdentifier: BuildingListingCell.reuseIdentifier)
    }

    private let emptyStateLabel = UILabel().then {
        $0.text = "축제 근처 빈 건물이 없습니다"
        $0.font = .paperlogy(.regular, size: 15)
        $0.textColor = UIColor(named: "A3A4A5")
        $0.textAlignment = .center
    }

    // TODO: 근처 빈 건물 매물 API 연동 전까지는 빈 배열을 기본값으로 사용
    init(festival: Festival, buildings: [PopularListing] = []) {
        self.festival = festival
        self.buildings = buildings
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = festival.fstvlNm
        setupLayout()

        headerCardView.configure(with: festival, nearbyVacantBuildingCount: buildings.count)

        tableView.dataSource = self
        tableView.isHidden = buildings.isEmpty
        emptyStateLabel.isHidden = !buildings.isEmpty
    }

    private func setupLayout() {
        view.addSubview(headerCardView)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)

        headerCardView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerCardView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        emptyStateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerCardView.snp.bottom).offset(120)
        }
    }
}

extension FestivalDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        buildings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BuildingListingCell.reuseIdentifier, for: indexPath) as! BuildingListingCell
        cell.configure(with: buildings[indexPath.row])
        return cell
    }
}
