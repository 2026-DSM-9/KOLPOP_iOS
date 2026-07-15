//
//  FestivalListViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class FestivalListViewController: UIViewController {

    private let festivalService = FestivalService()
    private var festivals: [Festival] = []
    private var searchDebounceTimer: Timer?

    private let searchFieldView = SearchFieldView().then {
        $0.setPlaceholder("지역 또는 축제 검색 (ex. 대전광역시, 벚꽃축제)")
    }

    private let tableView = UITableView().then {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 180
        $0.register(FestivalCardCell.self, forCellReuseIdentifier: FestivalCardCell.reuseIdentifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "지역축제 확인"
        setupLayout()
        tableView.dataSource = self
        tableView.delegate = self
        searchFieldView.textField.delegate = self
        searchFieldView.textField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        fetchFestivals()
    }

    private func setupLayout() {
        view.addSubview(searchFieldView)
        view.addSubview(tableView)

        searchFieldView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchFieldView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func fetchFestivals(keyword: String? = nil) {
        let completion: (Result<[Festival], Error>) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let festivals):
                    self.festivals = festivals.filter { $0.dDayText != "종료" }
                    self.tableView.reloadData()
                case .failure(let error):
                    print("축제 정보 조회 실패: \(error)")
                }
            }
        }

        // 검색어가 없을 때는 전체 목록(과거 데이터 포함) 대신 현재 진행 중/예정인 축제만
        // 내려주는 /festivals/upcoming을 사용한다. 검색어가 있을 때만 전체 목록에서 키워드로 찾는다.
        if let keyword, !keyword.isEmpty {
            festivalService.fetchFestivals(keyword: keyword, completion: completion)
        } else {
            festivalService.fetchUpcomingFestivals(completion: completion)
        }
    }

    @objc private func searchTextChanged() {
        searchDebounceTimer?.invalidate()
        let keyword = searchFieldView.textField.text
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            self?.fetchFestivals(keyword: keyword)
        }
    }
}

extension FestivalListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        festivals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FestivalCardCell.reuseIdentifier, for: indexPath) as! FestivalCardCell
        let festival = festivals[indexPath.row]
        cell.configure(with: festival, nearbyVacantBuildingCount: festival.nearbyListingCount)
        return cell
    }
}

extension FestivalListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = FestivalDetailViewController(festival: festivals[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FestivalListViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchDebounceTimer?.invalidate()
        fetchFestivals(keyword: textField.text)
        return true
    }
}
