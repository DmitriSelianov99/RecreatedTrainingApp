//
//  BrownTextField.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 15.07.2023.
//

import UIKit

class BrownTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        //delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = .specialBrown
        borderStyle = .none
        layer.cornerRadius = 10
        textColor = .specialGray
        font = .robotoBold20()
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        leftViewMode = .always
        clearButtonMode = .always
        returnKeyType = .done
        translatesAutoresizingMaskIntoConstraints = false
    }
}

//extension BrownTextField: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder() //становится неактивным
//        //textField.becomeFirstResponder() //становится активным - сразу клава появляется
//    }
//}
