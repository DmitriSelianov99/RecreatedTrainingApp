//
//  OnboardingViewController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 10.08.2023.
//

import UIKit

class OnboardingViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
    }
    
    private var collectionItem = 0
    
    private let onBoardingCollection = OnboardingCollectionView1()
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = .robotoBold20()
        button.tintColor = .specialGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pageControl.isEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private func setupViews(){
        view.backgroundColor = .specialGray
        view.addSubview(onBoardingCollection)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
    }
    
    private func setUserDefaults(){
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "OnBoardingWasViewed")
    }
    
//MARK: - objc
    @objc private func nextButtonTapped(){
        if collectionItem == 1 {
            nextButton.setTitle("START", for: .normal)
        }
        
        if collectionItem == 2 {
            setUserDefaults()
            dismiss(animated: true)
        } else {
            collectionItem += 1
            let index: IndexPath = [0 , collectionItem]
            onBoardingCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = collectionItem
        }
    }


}

//MARK: - EXTENSION
extension OnboardingViewController1 {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            onBoardingCollection.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            onBoardingCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            onBoardingCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            onBoardingCollection.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 50),

            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            pageControl.heightAnchor.constraint(equalToConstant: 30),

            
        ])
    }
}
