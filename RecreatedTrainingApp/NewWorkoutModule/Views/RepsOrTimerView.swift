//
//  RepsOrTimerView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 03.07.2023.
//

import UIKit
import RealmSwift

class RepsOrTimerView: UIView {
    
    private let repsOrTimerLabel = UILabel(text: "Reps or timer")
    private let chooseRepeatOrTimerLabel = UILabel(text: "Choose repeat or timer")
    
    private let subviewCover: UIView = {
        let subviewCover = UIView()
        subviewCover.backgroundColor = .specialBrown
        subviewCover.layer.cornerRadius = 10
        subviewCover.translatesAutoresizingMaskIntoConstraints = false
        return subviewCover
    }()
    
    private let setsView = WorkioutStackView(labelText: "Sets", maximumValue: 10, type: .sets)
    private let repsView = WorkioutStackView(labelText: "Reps", maximumValue: 50, type: .reps)
    private let timerView = WorkioutStackView(labelText: "Timer", maximumValue: 600, type: .timer)
    
    public var (sets, reps, timer) = (0, 0, 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(repsOrTimerLabel)
        addSubview(subviewCover)
        addSubview(setsView)
        addSubview(chooseRepeatOrTimerLabel)
        addSubview(repsView)
        addSubview(timerView)
    }
    
    private func setDelegate() {
        setsView.delegate = self
        repsView.delegate = self
        timerView.delegate = self
    }
    
    public func resetSliderViewValues(){
        setsView.resetValues()
        repsView.resetValues()
        timerView.resetValues()
    }
}

//MARK: - Extensions

extension RepsOrTimerView: SliderViewProtocol {
    func changeValue(type: SliderTypes, value: Int) {
        print(type, value)
        switch type{
        case .sets:
            sets = value
        case .reps:
            reps = value
            repsView.isActive = true
            timerView.isActive = false
            timer = 0
        case .timer:
            timer = value
            timerView.isActive = true
            repsView.isActive = false
            reps = 0
        }
    }
}

extension RepsOrTimerView {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            repsOrTimerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            repsOrTimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            repsOrTimerLabel.heightAnchor.constraint(equalToConstant: 16),
            
            subviewCover.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 3),
            subviewCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            subviewCover.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            subviewCover.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            setsView.topAnchor.constraint(equalTo: subviewCover.topAnchor, constant: 15),
            setsView.leadingAnchor.constraint(equalTo: subviewCover.leadingAnchor, constant: 15),
            setsView.trailingAnchor.constraint(equalTo: subviewCover.trailingAnchor, constant: -15),

            chooseRepeatOrTimerLabel.topAnchor.constraint(equalTo: setsView.bottomAnchor, constant: 15),
            chooseRepeatOrTimerLabel.centerXAnchor.constraint(equalTo: subviewCover.centerXAnchor),
            chooseRepeatOrTimerLabel.heightAnchor.constraint(equalToConstant: 16),
            
            repsView.topAnchor.constraint(equalTo: chooseRepeatOrTimerLabel.bottomAnchor, constant: 5),
            repsView.leadingAnchor.constraint(equalTo: subviewCover.leadingAnchor, constant: 15),
            repsView.trailingAnchor.constraint(equalTo: subviewCover.trailingAnchor, constant: -15),
            
            timerView.topAnchor.constraint(equalTo: repsView.bottomAnchor, constant: 15),
            timerView.leadingAnchor.constraint(equalTo: subviewCover.leadingAnchor, constant: 15),
            timerView.trailingAnchor.constraint(equalTo: subviewCover.trailingAnchor, constant: -15),
        ])
    }
}
