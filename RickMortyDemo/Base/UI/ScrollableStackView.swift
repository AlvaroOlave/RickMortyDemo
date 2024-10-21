//
//  ScrollableStackView.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 18/10/24.
//

import UIKit

final class ScrollableStackView: UIView {

    lazy var scrollView = UIScrollView()
    internal weak var view: UIView?
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(with view: UIView) {
        self.view = view
        self.view?.addSubview(scrollView)
        self.setupScrollView()
        switch self.stackView.axis {
        case .horizontal:
            setupStackViewHorizontally()
        case.vertical:
            setupStackViewVertically()
        @unknown default:
            break
        }
    }
    
    func setScrollDelegate(_ delegate: UIScrollViewDelegate) {
        self.scrollView.delegate = delegate
    }
    
    func enableScroll(isEnabled: Bool) {
        self.scrollView.isScrollEnabled = isEnabled
    }
    
    func setBounce(enabled: Bool) {
        self.scrollView.bounces = enabled
    }
    
    func updateScrollBackground() {
        guard let lastView = stackView.arrangedSubviews.last else { return }
        self.view?.backgroundColor = lastView.backgroundColor
    }
    
    func addArrangedSubview(_ view: UIView) {
        self.stackView.addArrangedSubview(view)
    }
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
    
    func insertArrangedSubview(_ view: UIView, at index: Int) {
        self.stackView.insertArrangedSubview(view, at: index)
    }
    
    func getArrangedSubviews() -> [UIView] {
        return self.stackView.arrangedSubviews
    }
    
    func setSpacing(_ spacing: CGFloat) {
        self.stackView.spacing = spacing
    }
    
    func setStackViewDistribution(_ distribution: UIStackView.Distribution) {
        self.stackView.distribution = distribution
    }
    
    func setScrollInsets(_ insets: UIEdgeInsets) {
        self.scrollView.contentInset = insets
    }
    
    func scrollRectToVisible(_ rect: CGRect, animated: Bool = true) {
        scrollView.scrollRectToVisible(rect, animated: animated)
    }
    
    func setContentOffset(_ point: CGPoint, animated: Bool) {
        self.scrollView.setContentOffset(point, animated: animated)
    }
    
    func removeAll() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    func removeAll<T>(ofType: T.Type) {
        stackView.arrangedSubviews.forEach {
            if $0 is T {
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
        }
    }
    
    var frameLayoutGuide: UILayoutGuide {
        self.scrollView.frameLayoutGuide
    }
    
    var isEmpty: Bool {
        stackView.arrangedSubviews.isEmpty
    }
    
    func center(_ point: CGPoint, animated: Bool = true) {
        guard let superviewOrigin = view?.superview?.frame.origin.x,
              let viewWidth = view?.frame.width,
              stackView.axis == .horizontal else { return }
        let scrollSizeLimit = scrollView.contentSize.width - viewWidth
        guard scrollSizeLimit > 0.0 else { return }
        let halfWidth = viewWidth / 2.0
        let horizontalPosition = point.x - halfWidth - superviewOrigin
        let sizeLimitedPoint: CGPoint
        if horizontalPosition <= 0.0 {
            sizeLimitedPoint = CGPoint(x: 0.0, y: point.y)
        } else if horizontalPosition > scrollSizeLimit {
            sizeLimitedPoint = CGPoint(x: scrollSizeLimit, y: point.y)
        } else {
            sizeLimitedPoint = CGPoint(x: horizontalPosition, y: point.y)
        }
        setContentOffset(sizeLimitedPoint, animated: animated)
    }
    
    func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        stackView.setCustomSpacing(spacing, after: arrangedSubview)
    }
}

private extension ScrollableStackView {
    func setupScrollView() {
        self.scrollView.backgroundColor = .clear
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addScrollConstraints()
    }
    
    func setupStackViewVertically() {
        guard let view = self.view else { return }
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.stackView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setupStackViewHorizontally() {
        guard let view = self.view else { return }
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.stackView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.stackView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    func addScrollConstraints() {
        guard let view = self.view else { return }
        NSLayoutConstraint.activate([
            self.scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.topConstraint(),
            self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func topConstraint() -> NSLayoutConstraint {
        guard let view = self.view else { return NSLayoutConstraint() }
        return self.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    }
}
