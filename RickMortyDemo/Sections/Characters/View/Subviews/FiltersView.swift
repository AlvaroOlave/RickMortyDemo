//
//  
//  FiltersView.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 23/10/24.
//
//
import UIKit
import AutolayoutDSL

final class FiltersView: UIView {
    
    @Published var selectedStatus: Status?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [aliveButton,
                                                       deadButton,
                                                       unknownButton])
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var aliveButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Status.Alive.rawValue, for: .normal)
        button.tintColor = Colors.rmPurple
        button.addTarget(self,
                         action: #selector(selectAlive),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var deadButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Status.Dead.rawValue, for: .normal)
        button.tintColor = Colors.rmPurple
        button.addTarget(self,
                         action: #selector(selectDead),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var unknownButton: UIButton = {
        let button = UIButton(configuration: .bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Status.unknown.rawValue, for: .normal)
        button.tintColor = Colors.rmPurple
        button.addTarget(self,
                         action: #selector(selectUnknown),
                         for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FiltersView {
    func setupView() {
        addSubview(stackView)
        addConstraints()
    }
    
    func addConstraints() {
        stackView.fill(self)
    }
    
    @objc func selectAlive() {
        aliveButton.isSelected.toggle()
        deadButton.isSelected = false
        unknownButton.isSelected = false
        selectedStatus = aliveButton.isSelected ? .Alive : nil
    }
    
    @objc func selectDead() {
        deadButton.isSelected.toggle()
        aliveButton.isSelected = false
        unknownButton.isSelected = false
        selectedStatus = deadButton.isSelected ? .Dead : nil
    }
    
    @objc func selectUnknown() {
        unknownButton.isSelected.toggle()
        aliveButton.isSelected = false
        deadButton.isSelected = false
        selectedStatus = unknownButton.isSelected ? .unknown : nil
    }
}
