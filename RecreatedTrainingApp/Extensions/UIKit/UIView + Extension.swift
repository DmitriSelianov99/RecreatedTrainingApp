//
//  UIView + Extension.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 21.06.2023.
//

import UIKit

extension UIView {
    
    func addShadowOnView(){
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1.0
    }
}
