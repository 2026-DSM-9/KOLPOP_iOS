//
//  PriceAnnotationView.swift
//  KOLPOP_iOS
//

import MapKit
import SnapKit
import Then

final class PriceAnnotationView: MKAnnotationView {

    static let reuseIdentifier = "PriceAnnotationView"

    private let badgeView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "E8E8E8")?.cgColor
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.12
        $0.layer.shadowRadius = 4
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    private let priceLabel = UILabel().then {
        $0.font = .paperlogy(.bold, size: 13)
        $0.textColor = UIColor(named: "1A1C1E")
        $0.textAlignment = .center
    }

    override var annotation: MKAnnotation? {
        didSet { configure() }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupLayout()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        canShowCallout = false
        addSubview(badgeView)
        badgeView.addSubview(priceLabel)

        priceLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        }
    }

    private func configure() {
        guard let listingAnnotation = annotation as? ListingAnnotation else { return }
        priceLabel.text = listingAnnotation.listing.priceBadge
        priceLabel.sizeToFit()

        let size = CGSize(width: priceLabel.bounds.width + 20, height: priceLabel.bounds.height + 12)
        bounds = CGRect(origin: .zero, size: size)
        badgeView.frame = bounds
        centerOffset = CGPoint(x: 0, y: -size.height / 2)
    }

    func setHighlighted(_ highlighted: Bool) {
        badgeView.backgroundColor = highlighted ? UIColor(named: "00AEEF") : .white
        priceLabel.textColor = highlighted ? .white : UIColor(named: "1A1C1E")
        layer.zPosition = highlighted ? 1 : 0
    }
}
