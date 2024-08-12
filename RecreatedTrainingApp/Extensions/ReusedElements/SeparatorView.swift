//
//  SeparatorView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 16.07.2023.
//

import UIKit

class SeparatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialLine
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
