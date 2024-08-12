//
//  UserButton.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 05.07.2023.
//

import UIKit

class UserButton: UIButton {
    
    convenience init(text: String, color: UIColor){
        self.init()
        backgroundColor = color
        setTitle(text, for: .normal)
        
        configure()
    }
    
//    override var buttonType: UIButton.ButtonType {
//        return .system
//       }
    
    private func configure(){
        
        layer.cornerRadius = 10
        tintColor = .white
        titleLabel?.font = .robotoBold16()
        setTitleColor(.lightGray, for: .highlighted) //имитация нажатия
        translatesAutoresizingMaskIntoConstraints = false
    }
}

