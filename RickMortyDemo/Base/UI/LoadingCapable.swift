//
//  LoadingCapable.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//

import UIKit
import LoadingDots

protocol LoadingCapable where Self: UIViewController {
    func showLoadingView(isVisible: Bool, completion: (()->Void)?)
}

extension LoadingCapable {
    
    func showLoadingView(isVisible: Bool, completion: (()->Void)? = nil) {
        guard let window = self.view?.window?.windowScene?.keyWindow else { return }
        
        if isVisible {
            LoadingViewManager.shared.showLoading(in: window,
                                                  completion: completion)
        } else {
            LoadingViewManager.shared.hideLoading(completion: completion)
        }
    }
}
    
final class LoadingViewManager {
    static let shared: LoadingViewManager = LoadingViewManager()
    
    private var loadingWorkItem: DispatchWorkItem?
    
    private var loadingView: LoadingDotsView?
    
    private init() {}
    
    func showLoading(in superview: UIView, completion: (()->Void)? = nil) {
        loadingWorkItem?.cancel()
        
        let work = DispatchWorkItem(block: { [weak self] in
            guard let self = self else { return }
            guard let work = self.loadingWorkItem,
                    !work.isCancelled else { return }
            let loading = createLoadingView()
            self.loadingView = loading
            
            superview.addSubview(loading)
            superview.bringSubviewToFront(loading)
            loading.fill(superview)
            
            completion?()
        })
        
        loadingWorkItem = work

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: work)
    }
    
    func hideLoading(completion: (()->Void)? = nil) {
        loadingWorkItem?.cancel()
        DispatchQueue.main.async { [weak self] in
            self?.loadingView?.removeFromSuperview()
            self?.loadingView = nil
            completion?()
        }
    }
    
    func createLoadingView() -> LoadingDotsView {
        let loading = LoadingDotsView(configuration: DotsConfiguration(dotsNumber: 5,
                                                                       dotRadius: 12.0,
                                                                       dotSeparation: 7.0,
                                                                       colors: [Colors.rmGreen ?? .green],
                                                                       animation: .bounce()))
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        return loading
    }
}
