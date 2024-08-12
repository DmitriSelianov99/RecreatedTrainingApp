//
//  DateAndRepeatView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 03.07.2023.
//

import UIKit

class DateAndRepeatView: UIView {
    
    private let dateAndRepeatLabel = UILabel(text: "Date and repeat")
    private let dateLabel = UILabel(text: "Date", font: .robotoMedium18()!, textColor: .specialGray)
    private let repeatLabel = UILabel(text: "Repeat every 7 days", font: .robotoMedium18()!, textColor: .specialGray)
    
    private let subviewCover: UIView = {
        let subviewCover = UIView()
        subviewCover.backgroundColor = .specialBrown
        subviewCover.layer.cornerRadius = 10
        subviewCover.translatesAutoresizingMaskIntoConstraints = false
        return subviewCover
    }()
    
    private let datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.tintColor = .specialGreen
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private let isRepeatSwitch: UISwitch = {
       let isRepetSwitch = UISwitch()
        isRepetSwitch.isOn = true
        isRepetSwitch.onTintColor = .specialGreen
        isRepetSwitch.translatesAutoresizingMaskIntoConstraints = false
        return isRepetSwitch
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateAndRepeatLabel)
        addSubview(subviewCover)
        addSubview(dateLabel)
        addSubview(repeatLabel)
        addSubview(datePickerView)
        addSubview(isRepeatSwitch)
    }
    
    public func getDateAndRepeat() -> (date: Date, repeatWorkout: Bool) {
        (datePickerView.date, isRepeatSwitch.isOn)
    }
    
    public func resetDateAndRepeat(){
        datePickerView.date = Date() //время на данный момент
        isRepeatSwitch.isOn = true
    }
    
}

extension DateAndRepeatView {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            dateAndRepeatLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            dateAndRepeatLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            dateAndRepeatLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            dateAndRepeatLabel.heightAnchor.constraint(equalToConstant: 16),
            
            subviewCover.topAnchor.constraint(equalTo: dateAndRepeatLabel.bottomAnchor, constant: 3),
            subviewCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            subviewCover.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            subviewCover.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            dateLabel.topAnchor.constraint(equalTo: subviewCover.topAnchor, constant: 17),
            dateLabel.leadingAnchor.constraint(equalTo: subviewCover.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: subviewCover.trailingAnchor, constant: -10),
            dateLabel.widthAnchor.constraint(equalToConstant: frame.width / 2),
            
            datePickerView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: subviewCover.trailingAnchor, constant: -10),
            
            repeatLabel.topAnchor.constraint(equalTo: datePickerView.bottomAnchor, constant: 10),
            repeatLabel.leadingAnchor.constraint(equalTo: subviewCover.leadingAnchor, constant: 10),
            //repeatLabel.widthAnchor.constraint(equalToConstant: frame.width / 2),
            
            isRepeatSwitch.centerYAnchor.constraint(equalTo: repeatLabel.centerYAnchor),
            isRepeatSwitch.trailingAnchor.constraint(equalTo: subviewCover.trailingAnchor, constant: -10)
            
        ])
    }
}
