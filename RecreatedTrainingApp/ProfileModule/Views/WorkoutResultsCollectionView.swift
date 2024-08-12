//
//  WorkoutResultsCollectionView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 19.07.2023.
//

import UIKit

protocol SetProgressTargetProtocol: AnyObject {
    func setProgress()
}

class WorkoutResultsCollectionView: UICollectionView {
    
    weak var setProgressDelegate: SetProgressTargetProtocol?
    
    private let collectionLayout = UICollectionViewFlowLayout()
    private let idCollectionCell = "idCollectionCell"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionLayout)
        
        setDelegates()
        configure()
        setupLayout()
        register(WorkoutResultsCollectionViewCell.self, forCellWithReuseIdentifier: idCollectionCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var resultWorkout = [ResultWorkout]()
    
    private func configure(){
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    private func setupLayout(){
        collectionLayout.scrollDirection = .horizontal
    }
    
    private func setDelegates(){
        delegate = self
        dataSource = self
    }
    
    private func getWorkoutNames() -> [String] {
        var nameArray = [String]()
        let allWorkouts = RealmManager.shared.getResultWorkoutModel()
        
        for workoutModel in allWorkouts {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    public func getWorkoutResults(){
        let nameArray = getWorkoutNames()
        let workoutArray = RealmManager.shared.getResultWorkoutModel()
        
        for name in nameArray {
            let predicate = NSPredicate(format: "workoutName = '\(name)'")
            let filteredArray = workoutArray.filter(predicate).sorted(byKeyPath: "workoutName")
            var result = 0
            var image: Data?
            filteredArray.forEach { model in
                result += model.workoutReps * model.workoutSets
                image = model.workoutImage
            }
            
            let resultModel = ResultWorkout(name: name, result: result, imageData: image)
            resultWorkout.append(resultModel)
        }
    }
}

//MARK: - Extensions
extension WorkoutResultsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell", indexPath)
        setProgressDelegate?.setProgress()
    }
}

extension WorkoutResultsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultWorkout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCollectionCell, for: indexPath) as? WorkoutResultsCollectionViewCell
        else { return UICollectionViewCell()}
        cell.backgroundColor = (indexPath.row % 4 == 0 || indexPath.row % 4 == 3 ? .specialGreen : .specialDarkYellow)
        
        let model = resultWorkout[indexPath.row]
        cell.configure(model: model)
        
        return cell
    }
}

extension WorkoutResultsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width * 0.48, height: 110)
    }
}
