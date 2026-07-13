//
//  FestivalCalendarViewController.swift
//  KOLPOP_iOS
//

import UIKit
import SnapKit
import Then

final class FestivalCalendarViewController: UIViewController {

    private let festivalService = FestivalService()
    private var allFestivals: [Festival] = []

    private var displayedMonth: Date
    private var selectedDate: Date

    private let calendar = Calendar.current

    private let calendarMonthView = CalendarMonthView()

    private let detailContainerView = UIView().then {
        $0.backgroundColor = UIColor(named: "F8F8F8")
        $0.layer.cornerRadius = 16
    }

    private let selectedDateLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 16)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    private let emptyLabel = UILabel().then {
        $0.text = "축제 일정이 없습니다."
        $0.font = .paperlogy(.medium, size: 15)
        $0.textColor = UIColor(named: "1A1C1E")
    }

    private let festivalListStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }

    init() {
        let now = Date()
        self.displayedMonth = now
        self.selectedDate = now
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "지역축제 캘린더"
        setupLayout()

        calendarMonthView.onPrevMonth = { [weak self] in self?.moveMonth(by: -1) }
        calendarMonthView.onNextMonth = { [weak self] in self?.moveMonth(by: 1) }
        calendarMonthView.onSelectDay = { [weak self] day in self?.selectDay(day) }

        fetchFestivals()
    }

    private func setupLayout() {
        detailContainerView.addSubview(selectedDateLabel)
        detailContainerView.addSubview(emptyLabel)
        detailContainerView.addSubview(festivalListStackView)

        view.addSubview(calendarMonthView)
        view.addSubview(detailContainerView)

        calendarMonthView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        detailContainerView.snp.makeConstraints { make in
            make.top.equalTo(calendarMonthView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        selectedDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        festivalListStackView.snp.makeConstraints { make in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    private func fetchFestivals() {
        festivalService.fetchFestivals(numOfRows: 1000) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let festivals):
                    self.allFestivals = festivals
                    self.reloadCalendar()
                    self.reloadDetail()
                case .failure(let error):
                    print("축제 캘린더 조회 실패: \(error)")
                }
            }
        }
    }

    private func reloadCalendar() {
        let today = Date()
        let todayDay: Int? = calendar.isDate(today, equalTo: displayedMonth, toGranularity: .month)
            ? calendar.component(.day, from: today)
            : nil
        let selectedDay: Int? = calendar.isDate(selectedDate, equalTo: displayedMonth, toGranularity: .month)
            ? calendar.component(.day, from: selectedDate)
            : nil

        calendarMonthView.configure(
            month: displayedMonth,
            selectedDay: selectedDay,
            todayDay: todayDay,
            eventDays: eventDays(in: displayedMonth)
        )
    }

    private func eventDays(in month: Date) -> Set<Int> {
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] }
        let components = calendar.dateComponents([.year, .month], from: month)

        var days = Set<Int>()
        for day in range {
            var dayComponents = components
            dayComponents.day = day
            guard let date = calendar.date(from: dayComponents) else { continue }
            if !festivals(on: date).isEmpty {
                days.insert(day)
            }
        }
        return days
    }

    private func festivals(on date: Date) -> [Festival] {
        let target = calendar.startOfDay(for: date)
        return allFestivals.filter { festival in
            guard let start = festival.startDate, let end = festival.endDate else { return false }
            return calendar.startOfDay(for: start) <= target && target <= calendar.startOfDay(for: end)
        }
    }

    private func moveMonth(by value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) else { return }
        displayedMonth = newMonth
        reloadCalendar()
    }

    private func selectDay(_ day: Int) {
        var components = calendar.dateComponents([.year, .month], from: displayedMonth)
        components.day = day
        guard let date = calendar.date(from: components) else { return }
        selectedDate = date
        reloadCalendar()
        reloadDetail()
    }

    private func reloadDetail() {
        let month = calendar.component(.month, from: selectedDate)
        let day = calendar.component(.day, from: selectedDate)
        selectedDateLabel.text = "\(month)월 \(day)일"

        let matches = festivals(on: selectedDate)
        emptyLabel.isHidden = !matches.isEmpty
        festivalListStackView.isHidden = matches.isEmpty

        festivalListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for festival in matches {
            festivalListStackView.addArrangedSubview(makeFestivalRow(title: festival.fstvlNm))
        }
    }

    private func makeFestivalRow(title: String) -> UIView {
        let dotView = UIView().then {
            $0.backgroundColor = UIColor(named: "EA8C21")
            $0.layer.cornerRadius = 3
        }
        let label = UILabel().then {
            $0.text = title
            $0.font = .paperlogy(.semiBold, size: 15)
            $0.textColor = UIColor(named: "1A1C1E")
            $0.numberOfLines = 0
        }

        let row = UIView()
        row.addSubview(dotView)
        row.addSubview(label)

        dotView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(label).offset(-1)
            make.width.height.equalTo(6)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(dotView.snp.trailing).offset(10)
            make.trailing.top.bottom.equalToSuperview()
        }
        return row
    }
}
