//
//  WorkoutResultsCollectionViewCell.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 19.07.2023.
//

import UIKit

class WorkoutResultsCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let exerciseLabel = UILabel(text: "BICEPS", font: .robotoBold24() ?? .systemFont(ofSize: 24), textColor: .white)
    private let exerciseImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "biceps")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private let repsCountLabel = UILabel(text: "180", font: .robotoBold48()!, textColor: .white)
    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialGreen
        layer.cornerRadius = 10
        
        addSubview(exerciseLabel)
        addSubview(exerciseImageView)
        addSubview(repsCountLabel)
    }
    
    public func configure(model: ResultWorkout){
        exerciseLabel.text = model.name
        repsCountLabel.text = "\(model.result)"
        
        guard let data = model.imageData else { return }
        exerciseImageView.image = UIImage(data: data)
    }
}

extension WorkoutResultsCollectionViewCell {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            exerciseLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            exerciseLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            exerciseImageView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 10),
            exerciseImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            exerciseImageView.heightAnchor.constraint(equalToConstant: frame.height * 0.5),
            exerciseImageView.widthAnchor.constraint(equalToConstant: frame.height * 0.5),
            
            repsCountLabel.topAnchor.constraint(equalTo: exerciseImageView.topAnchor),
            repsCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
}
