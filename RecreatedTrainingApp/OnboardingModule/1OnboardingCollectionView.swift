//
//  OnboardingCollectionView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 10.08.2023.
//

import UIKit

struct onboardingStruct {
    let topLabel: String
    let bottomLabel: String
    let image: UIImage
}

class OnboardingCollectionView1: UICollectionView {
    
    private let collectionLayout = UICollectionViewLayout()
    private let idCell = "idCell"
    private var onboardingArray = [onboardingStruct]()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionLayout)
        
        setDelegates()
        configure()
        register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: idCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let firstImage = UIImage(named: "firstImage"),
              let secondImage = UIImage(named: "secondImage"),
              let thirdImage = UIImage(named: "thirdImage")
        else { return }
        
        let firstScreen = onboardingStruct(topLabel: "Have a good health",
                                           bottomLabel: "Being healthy is all, no health is nothing. So why do not we",
                                           image: firstImage)
        let secondScreen = onboardingStruct(topLabel: "Be stronger",
                                            bottomLabel: "Take 30 minutes of bodybuilding every day to get physically fit and healthy.",
                                            image: secondImage)
        let thirdScreen = onboardingStruct(topLabel: "Have nice body",
                                           bottomLabel: "Bad body shape, poor sleep, lack of strength, weight gain, weak bones, easily traumatized body, depressed, stressed, poor metabolism, poor resistance",
                                           image: thirdImage)
        onboardingArray = [firstScreen, secondScreen, thirdScreen]
        
    
    }
    
    private func setDelegates(){
        delegate = self
        dataSource = self
    }
    
}

//MARK: - EXTENSIONS
extension OnboardingCollectionView1: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath) as! OnboardingCollectionViewCell1
        let model = onboardingArray[indexPath.row]
        cell.setConfigure(model: model)
        return cell
    }
}

extension OnboardingCollectionView1: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}
