//
//  ExercisesTableViewCell.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 29.06.2023.
//

import UIKit

class ExercisesTableViewCell: UITableViewCell {
    
    static let idTableViewCell = "idTableViewCell"
 
//MARK: - Elements
    private let exerciseLabel: UILabel = {
       let label = UILabel()
        label.text = "Biceps"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let beforeLabel: UILabel = {
       let label = UILabel()
        label.text = "Before: 18"
        label.font = .robotoMedium14()
        label.textColor = .specialLightBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nowLabel: UILabel = {
       let label = UILabel()
        label.text = "Now: 20"
        label.font = .robotoMedium14()
        label.textColor = .specialLightBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let counterLabel = UILabel(text: "+2", font: .robotoMedium24()!, textColor: .specialGreen)
    private var beforeNowStackView = UIStackView()
 
//MARK: - Functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(exerciseLabel)
        beforeNowStackView = UIStackView(arrangedSubviews: [beforeLabel, nowLabel], axis: .horizontal, spacing: 10)
        addSubview(beforeNowStackView)
        addSubview(counterLabel)
        addSubview(separatorView)
    }
    
    public func configure(differenceWorkout: DifferenceWorkout){
        exerciseLabel.text = differenceWorkout.name
        beforeLabel.text = "Before: \(differenceWorkout.firstReps)"
        nowLabel.text = "Now: \(differenceWorkout.lastReps)"
        
        let difference = differenceWorkout.lastReps - differenceWorkout.firstReps
        counterLabel.text = "\(difference)"
        
        switch difference {
        case ..<0: counterLabel.textColor = .specialGreen
        case 1...: counterLabel.textColor = .specialYellow
        default: counterLabel.textColor = .specialGray
        }
    }
    
}//class

//MARK: - Extensions
extension ExercisesTableViewCell {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            exerciseLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            exerciseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            exerciseLabel.widthAnchor.constraint(equalToConstant:  frame.width / 2),
            
            beforeNowStackView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 3),
            beforeNowStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            //beforeNowStackView.widthAnchor.constraint(equalToConstant: frame.width / 2.5),
            
            counterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            counterLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separatorView.topAnchor.constraint(equalTo: beforeNowStackView.bottomAnchor, constant: 5)
        ])
    }
}
