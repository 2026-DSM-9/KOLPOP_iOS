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
            make.bottom.equalToSuperview().offset(-20)
        }
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

        days = Array(repeating: nil, count: leadingBlanks) + range.map { $0 }
        collectionView.reloadData()
        invalidateIntrinsicContentSize()
        collectionView.layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: collectionView.contentSize.height + 20 + 24 + 20 + 8 + 20)
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
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let day = days[indexPath.item] else { return }
        onSelectDay?(day)
    }
}
