//
//  LabelAndTextfieldView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 02.08.2023.
//

import UIKit

class LabelAndTextfieldView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String){
        self.init()
        nameLabel.text = name
    }
    
    private let nameTextField = BrownTextField()
    private var nameLabel = UILabel(text: "Undefined")
    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        addSubview(nameTextField)
    }
}

extension LabelAndTextfieldView {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

