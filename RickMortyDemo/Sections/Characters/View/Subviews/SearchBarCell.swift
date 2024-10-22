//
//  
//  SearchBarCell.swift
//  RickMortyDemo
//
//  Created by Álvaro Olave Bañeres on 21/10/24.
//
//
import UIKit
import Combine
import AutolayoutDSL

final class SearchBarCell: UIView {
    
    @Published var searchText: String?
    
    private lazy var textField: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.attributedPlaceholder = NSAttributedString(string: String(localized: "Search..."),
                                                             attributes: [.foregroundColor: UIColor.systemGray6])
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = Colors.rmPurple?.withAlphaComponent(0.9)
        textfield.textColor = .systemGray6
        textfield.clearButtonMode = .always
        textfield.delegate = self
        textfield.addTarget(self, 
                            action: #selector(textDidChange),
                            for: .editingChanged)
        return textfield
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

private extension SearchBarCell {
    func setupView() {
        backgroundColor = .clear
        addSubview(textField)
        addConstraints()
    }
    
    func addConstraints() {
        textField.fill(self)
    }
    
    @objc func textDidChange() {
        searchText = (textField.text?.count ?? 0) > 2 ? textField.text : ""
    }
}

extension SearchBarCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
