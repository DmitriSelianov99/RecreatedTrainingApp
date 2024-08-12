//
//  WorkioutStackView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 05.07.2023.
//

import UIKit

protocol SliderViewProtocol: AnyObject {
    func changeValue(type: SliderTypes, value: Int)
}

class WorkioutStackView: UIView {
    
    weak var delegate: SliderViewProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(labelText: String, maximumValue: Float, type: SliderTypes){
        self.init()
        
        setsLabel.text = labelText
        setsSlider.maximumValue = maximumValue
        sliderType = type
        setupViews()
        setConstraints()
    }
    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        setsStackView = UIStackView(arrangedSubviews: [setsLabel, setsCounterLabel], axis: .horizontal, spacing: 10)
        setsStackView.distribution = .equalSpacing
        
        setsSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        addSubview(setsStackView)
        addSubview(setsSlider)
    }
    
    private let setsLabel = UILabel(text: "NULL", font: .robotoMedium18()!, textColor: .specialGray)
    private let setsCounterLabel = UILabel(text: "0", font: .robotoMedium24()!, textColor: .specialGray)
    private var setsStackView = UIStackView()
    
    private var sliderType: SliderTypes?
    
    public var isActive: Bool = true {
        didSet {
            if self.isActive {
                setsLabel.alpha = 1
                setsCounterLabel.alpha = 1
                setsSlider.alpha = 1
            } else {
                setsLabel.alpha = 0.5
                setsCounterLabel.alpha = 0.5
                setsSlider.alpha = 0.5
                setsSlider.value = 0
                setsCounterLabel.text = "0"
            }
        }
    }
    
    private lazy var setsSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 0
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        //slider.addTarget(self, action: #selector(changeSetsSliderValue), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    public func resetValues(){
        setsCounterLabel.text = "0"
        setsSlider.value = 0
        isActive = true
    }
    
   
//MARK: - objc
    @objc private func sliderChanged(){
        let intValueSlider = Int(setsSlider.value)
        setsCounterLabel.text = sliderType == .timer ? intValueSlider.getTimeFromSecond() : "\(intValueSlider)"
        guard let type = sliderType else { return }
        delegate?.changeValue(type: type, value: intValueSlider)
    }
}

//MARK: - Extensions
extension WorkioutStackView {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            setsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            setsSlider.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 5),
            setsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            setsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            setsSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
