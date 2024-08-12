//
//  CloseButton.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 18.07.2023.
//

import UIKit

class CloseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        //addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
