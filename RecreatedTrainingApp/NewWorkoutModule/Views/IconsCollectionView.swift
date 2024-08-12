//
//  IconsView.swift
//  MyFirstApp_20.02.
//
//  Created by Дмитрий Сельянов on 14.07.2023.
//

import UIKit



class IconsCollectionView: UICollectionView {
    
    private let collectionLayout = UICollectionViewFlowLayout()
    private let idIconCell = "idIconCell"
    private var workoutImage = UIImage(named: "")
    
    private let imageArray = ["abs", "biceps", "dumbbell", "kettlebell", "stopWatch"]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionLayout)
        
        configure()
        setLayouts()
        setDelegates()
        register(IconsCollectionViewCell.self, forCellWithReuseIdentifier: idIconCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLayouts(){
        collectionLayout.minimumInteritemSpacing = 8
        collectionLayout.scrollDirection = .horizontal
    }
    
    private func setDelegates(){
        delegate = self
        dataSource = self
    }
    
    public func getImage() -> Data {
        workoutImage?.pngData() ?? Data()
    }
}

extension IconsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("image tapped")
        workoutImage = UIImage(named: imageArray[indexPath.row])?.withRenderingMode(.alwaysTemplate)
    }
}

extension IconsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idIconCell, for: indexPath) as? IconsCollectionViewCell
        else { return UICollectionViewCell() }
        cell.workoutTypeImage.image = UIImage(named: imageArray[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        return cell
    }
}

extension IconsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width / 4,
            height: collectionView.frame.height * 0.8)
    }
}
