//
//  ChipWrapView.swift
//  KOLPOP_iOS
//

import UIKit

/// 가변 개수의 칩(태그) 뷰를 좌측부터 배치하다 폭이 넘치면 다음 줄로 넘기는 컨테이너.
final class ChipWrapView: UIView {

    var horizontalSpacing: CGFloat = 8
    var verticalSpacing: CGFloat = 8

    private var chipViews: [UIView] = []
    private var cachedHeight: CGFloat = 0

    func setChips(_ views: [UIView]) {
        chipViews.forEach { $0.removeFromSuperview() }
        chipViews = views
        views.forEach { addSubview($0) }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutChips(width: bounds.width)
    }

    @discardableResult
    private func layoutChips(width: CGFloat) -> CGFloat {
        guard width > 0, !chipViews.isEmpty else {
            updateCachedHeight(0)
            return 0
        }

        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in chipViews {
            let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            if x > 0, x + size.width > width {
                x = 0
                y += rowHeight + verticalSpacing
                rowHeight = 0
            }
            view.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
            x += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }

        let totalHeight = y + rowHeight
        updateCachedHeight(totalHeight)
        return totalHeight
    }

    private func updateCachedHeight(_ height: CGFloat) {
        guard height != cachedHeight else { return }
        cachedHeight = height
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: cachedHeight)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: layoutChips(width: size.width))
    }
}
