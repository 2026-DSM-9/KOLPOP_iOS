//
//  CalendarMonthView.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class CalendarMonthView: UIView {

    var onPrevMonth: (() -> Void)?
    var onNextMonth: (() -> Void)?
    var onSelectDay: ((Int) -> Void)?

    private static let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]

    private static let monthTitleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }()

    private var days: [Int?] = []
    private var selectedDay: Int?
    private var todayDay: Int?
    private var eventDays: Set<Int> = []

    private let prevButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = UIColor(named: "1A1C1E")
    }

    private let nextButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = UIColor(named: "1A1C1E")
    }

    private let monthTitleLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 19)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.textAlignment = .center
    }

    private let weekdayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 12
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.reuseIdentifier)
    }

    /// 한 달은 최대 6주까지 나올 수 있어 행 수를 6으로 고정해 달력 높이를 안정적으로 유지한다.
    private static let rowCount = 6
    private static let cellHeight: CGFloat = 44
    private static let lineSpacing: CGFloat = 12

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupWeekdayHeader()
        collectionView.dataSource = self
        collectionView.delegate = self
        prevButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = UIColor(named: "F8F8F8")
        layer.cornerRadius = 16

        [prevButton, monthTitleLabel, nextButton, weekdayStackView, collectionView].forEach {
            addSubview($0)
        }

        monthTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        prevButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthTitleLabel)
            make.trailing.equalTo(monthTitleLabel.snp.leading).offset(-16)
        }
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthTitleLabel)
            make.leading.equalTo(monthTitleLabel.snp.trailing).offset(16)
        }

        weekdayStackView.snp.makeConstraints { make in
            make.top.equalTo(monthTitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(weekdayStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(gridHeight)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    private var gridHeight: CGFloat {
        CGFloat(Self.rowCount) * Self.cellHeight + CGFloat(Self.rowCount - 1) * Self.lineSpacing
    }

    private func setupWeekdayHeader() {
        Self.weekdaySymbols.forEach { symbol in
            let label = UILabel().then {
                $0.text = symbol
                $0.font = .paperlogy(.bold, size: 16)
                $0.textColor = UIColor(named: "1A1C1E")
                $0.textAlignment = .center
            }
            weekdayStackView.addArrangedSubview(label)
        }
    }

    func configure(month: Date, selectedDay: Int?, todayDay: Int?, eventDays: Set<Int>) {
        monthTitleLabel.text = Self.monthTitleFormatter.string(from: month)
        self.selectedDay = selectedDay
        self.todayDay = todayDay
        self.eventDays = eventDays

        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: month) ?? (1..<31)
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) ?? month
        let leadingBlanks = calendar.component(.weekday, from: firstDayOfMonth) - 1

        var newDays = Array(repeating: nil as Int?, count: leadingBlanks) + range.map { $0 }
        let totalCells = Self.rowCount * 7
        if newDays.count < totalCells {
            newDays += Array(repeating: nil, count: totalCells - newDays.count)
        }
        days = newDays
        collectionView.reloadData()
    }

    @objc private func prevTapped() { onPrevMonth?() }
    @objc private func nextTapped() { onNextMonth?() }
}

extension CalendarMonthView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarDayCell.reuseIdentifier, for: indexPath) as! CalendarDayCell
        let day = days[indexPath.item]

        let style: CalendarDayCell.Style
        if let day, day == selectedDay {
            style = .selected
        } else if let day, day == todayDay {
            style = .today
        } else {
            style = .normal
        }

        let hasEvent = day.map { eventDays.contains($0) } ?? false
        cell.configure(day: day, style: style, hasEvent: hasEvent)
        return cell
    }
}

extension CalendarMonthView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 나눗셈 결과를 그대로 쓰면 누적 오차로 7번째 셀이 다음 줄로 밀려 6개씩만 배치되므로 내림 처리한다.
        let width = (collectionView.bounds.width / 7).rounded(.down)
        return CGSize(width: width, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let day = days[indexPath.item] else { return }
        onSelectDay?(day)
    }
}
