//
//  TargetView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 19.07.2023.
//

import UIKit

class TargetView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let targetLabel = UILabel(text: "TARGET: 20 workouts", font: .robotoBold16()!, textColor: .specialGray)
    
    private var targetStackView = UIStackView()
    private let targetFromLabel = UILabel(text: "0", font: .robotoBold24()!, textColor: .specialGray)
    public let targetToLabel = UILabel(text: "20", font: .robotoBold24()!, textColor: .specialGray)
    
    public let progressBarView: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .bar)
        progressBar.trackTintColor = .specialBrown
        progressBar.progressTintColor = .specialGreen
        progressBar.clipsToBounds = true
        progressBar.setProgress(0, animated: false)
        progressBar.layer.sublayers?[1].cornerRadius = 14
        progressBar.subviews[1].clipsToBounds = true
        progressBar.layer.cornerRadius = 14
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    private let targetBackgroundView: UIView = {
        let targetBackground = UIView()
        targetBackground.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.8823529412, blue: 0.8196078431, alpha: 1)
        targetBackground.layer.cornerRadius = 15
        targetBackground.translatesAutoresizingMaskIntoConstraints = false
        return targetBackground
    }()
    private let targetProgressView: UIView = {
        let targetProgress = UIView()
        targetProgress.backgroundColor = .specialGreen
        targetProgress.layer.cornerRadius = 15
        targetProgress.translatesAutoresizingMaskIntoConstraints = false
        return targetProgress
    }()

    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(targetLabel)
        
        targetStackView = UIStackView(arrangedSubviews: [targetFromLabel, targetToLabel],
                                      axis: .horizontal,
                                      spacing: 25)
        addSubview(targetStackView)
        //addSubview(targetBackgroundView)
        //targetBackgroundView.addSubview(targetProgressView)
        addSubview(progressBarView)
    }
}

extension TargetView {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            targetLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            targetLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            targetLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            targetStackView.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 15),
            targetStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            targetStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            progressBarView.topAnchor.constraint(equalTo: targetStackView.bottomAnchor, constant: 0),
            progressBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            progressBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            progressBarView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
