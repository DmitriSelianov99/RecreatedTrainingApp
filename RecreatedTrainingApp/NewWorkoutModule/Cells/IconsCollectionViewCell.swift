//
//  IconsCollectionViewCell.swift
//  MyFirstApp_20.02.
//
//  Created by Дмитрий Сельянов on 14.07.2023.
//

import UIKit

class IconsCollectionViewCell: UICollectionViewCell {
    
    public let workoutTypeImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "biceps")?.withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                layer.borderColor = UIColor.specialGreen.cgColor
                layer.borderWidth = 3
            } else {
                layer.borderWidth = 1
                layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        addSubview(workoutTypeImage)
    }
}

extension IconsCollectionViewCell {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            workoutTypeImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            workoutTypeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            workoutTypeImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            workoutTypeImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
