//
//  WeatherView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 21.06.2023.
//

import UIKit

class WeatherView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let weatherLabel: UILabel = {
       let label = UILabel()
        label.text = "Loading..."
        label.textColor = .specialGray
        label.font = .robotoMedium18()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "Хорошая погода, чтобы позаниматься на улице"
        label.textColor = .specialGray
        label.font = .robotoMedium14()
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "sun")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        layer.cornerRadius = 10
        addShadowOnView()
        addSubview(weatherLabel)
        addSubview(weatherDescriptionLabel)
        addSubview(weatherImageView)
    }
    
    public func updateImage(data: Data){
        guard let image = UIImage(data: data) else { return }
        weatherImageView.image = image
    }
    
    public func updateLabels(model: WeatherModel) {
        weatherLabel.text = model.weather[0].myDescription + " \(model.main.temperatureCelsius)°C"
        
        switch model.weather[0].weatherDescription {
        case "clear sky": weatherDescriptionLabel.text = "Отличная погода для занятий на свежем воздухе!"
        case "few clouds": weatherDescriptionLabel.text = ""
        case "scattered clouds": weatherDescriptionLabel.text = ""
        case "broken clouds": weatherDescriptionLabel.text = ""
        case "shower rain": weatherDescriptionLabel.text = ""
        case "rain": weatherDescriptionLabel.text = ""
        case "thunderstorm": weatherDescriptionLabel.text = ""
        case "snow": weatherDescriptionLabel.text = ""
        case "mist": weatherDescriptionLabel.text = ""
        case "overcast clouds": weatherDescriptionLabel.text = ""
        default:
            weatherDescriptionLabel.text = "Нет рекомендаций"
        }
    }
}

extension WeatherView {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            
            weatherDescriptionLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 5),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            weatherImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            weatherImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
    }
}
