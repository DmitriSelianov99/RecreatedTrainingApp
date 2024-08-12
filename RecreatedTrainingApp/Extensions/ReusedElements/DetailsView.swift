//
//  DetailsView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 16.07.2023.
//

import UIKit

protocol NextSetProtocol: AnyObject {
    func nextSetTapped()
    func editingTapped()
}

class DetailsView: UIView {
    
    weak var cellNextSetDelegate: NextSetProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(typeOfRepeats: String, quantityOfRepeats: String) {
        self.init()
        
        typeOfRepeatsLabel.text = typeOfRepeats
    }
    
    private let detailsLabel = UILabel(text: "Details")
    
    private let coverView: UIView = {
       let coverView = UIView()
        coverView.backgroundColor = .specialBrown
        coverView.layer.cornerRadius = 10
        coverView.translatesAutoresizingMaskIntoConstraints = false
        return coverView
    }()
    
    private let exerciseLabel = UILabel(text: "Undefined", font: .robotoMedium24() ?? .systemFont(ofSize: 24), textColor: .specialGray)
    
    private let setsLabel = UILabel(text: "Sets", font: .robotoMedium18() ?? .systemFont(ofSize: 18), textColor: .specialGray)
    private let setsCounterLabel = UILabel(text: "1/4", font: .robotoMedium24() ?? .systemFont(ofSize: 24), textColor: .specialGray)
    private var setsStackView = UIStackView()
    private let setsSeparator = SeparatorView()
    
    private let typeOfRepeatsLabel = UILabel(text: "Undefined", font: .robotoMedium18() ?? .systemFont(ofSize: 18), textColor: .specialGray)
    private let repeatCounterLabel = UILabel(text: "20", font: .robotoMedium24() ?? .systemFont(ofSize: 24), textColor: .specialGray)
    private var repeatStackView = UIStackView()
    private let repeatSeparator = SeparatorView()
    
    private lazy var editingButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Editing", for: .normal)
        btn.setImage(UIImage(named: "editing")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.backgroundColor = .none
        //btn.setTitleColor(.specialLightBrown, for: .normal)
        btn.tintColor = .specialLightBrown
        btn.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 17) ?? .systemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var nextSetButton = UserButton(text: "NEXT SET", color: .specialYellow)
    
    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailsLabel)
        addSubview(coverView)
        
        addSubview(exerciseLabel)
        
        setsStackView = UIStackView(arrangedSubviews: [setsLabel, setsCounterLabel], axis: .horizontal, spacing: 10)
        addSubview(setsStackView)
        addSubview(setsSeparator)
        
        repeatStackView = UIStackView(arrangedSubviews: [typeOfRepeatsLabel, repeatCounterLabel], axis: .horizontal, spacing: 10)
        addSubview(repeatStackView)
        addSubview(repeatSeparator)
        
        addSubview(editingButton)
        nextSetButton.setTitleColor(.specialGray, for: .normal)
        nextSetButton.addTarget(self, action: #selector(nextSetButtonTapped), for: .touchUpInside)
        addSubview(nextSetButton)
    }
    
    public func refreshLabels(model: WorkoutModel, numberOfSet: Int){
        exerciseLabel.text = model.workoutName
        setsCounterLabel.text = "\(numberOfSet)/\(model.workoutSets)"
        
        if model.workoutTimer == 0 {
            repeatCounterLabel.text = "\(model.workoutReps)"
        } else {
            repeatCounterLabel.text = "\(model.workoutTimer.getTimeFromSecond())"
        }
        
    }

//MARK: - objc
    @objc private func editingButtonTapped(){
        cellNextSetDelegate?.editingTapped()
    }
    
    @objc private func nextSetButtonTapped(){
        cellNextSetDelegate?.nextSetTapped()
    }
}

//MARK: - Extensions
extension DetailsView {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            detailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            detailsLabel.heightAnchor.constraint(equalToConstant: 16),
            
            coverView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 3),
            coverView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            coverView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            coverView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            exerciseLabel.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 15),
            exerciseLabel.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
            exerciseLabel.heightAnchor.constraint(equalToConstant: 26),
            
            setsStackView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 10),
            setsStackView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 15),
            setsStackView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -15),
            
            setsSeparator.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 0),
            setsSeparator.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 15),
            setsSeparator.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -15),
            setsSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            repeatStackView.topAnchor.constraint(equalTo: setsSeparator.bottomAnchor, constant: 20),
            repeatStackView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 15),
            repeatStackView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -15),
            
            repeatSeparator.topAnchor.constraint(equalTo: repeatStackView.bottomAnchor, constant: 0),
            repeatSeparator.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 15),
            repeatSeparator.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -15),
            repeatSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            editingButton.topAnchor.constraint(equalTo: repeatSeparator.bottomAnchor, constant: 15),
            editingButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -15),
            editingButton.heightAnchor.constraint(equalToConstant: 20),
            
            nextSetButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 15),
            nextSetButton.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 15),
            nextSetButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -15),
            nextSetButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
