//
//  StatisticViewController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 29.06.2023.
//

import UIKit

class StatisticViewController: UIViewController {

//MARK: - Elements
    private let headerLabel = UILabel(text: "STATISTIC", font: .robotoMedium24()!, textColor: .specialGray)
    private let exercisesLabel = UILabel(text: "Exercises")
    private let exercisesTableView = ExercisesTableView()
    
    private lazy var segmentedControl: UISegmentedControl = {
       let segmentedControl = UISegmentedControl(items: ["Неделя", "Месяц"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialYellow
        let font = UIFont(name: "Roboto-Medium", size: 16)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor : UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.font : font as Any,
                                                 .foregroundColor : UIColor.specialGray], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private var workoutArray = [WorkoutModel]()
    private var differenceArray = [DifferenceWorkout]()

//MARK: - Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setStartScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
    }
    
    private func setupViews(){
        view.backgroundColor = .specialBackground    
        view.addSubview(headerLabel)
        view.addSubview(exercisesLabel)
        view.addSubview(exercisesTableView)
        view.addSubview(segmentedControl)
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
    
    private func getDifferenceModel(dateStart: Date){
        let dateEnd = Date()
        let nameArray = getWorkoutNames()
        let allWorkouts = RealmManager.shared.getResultWorkoutModel()
        
        for name in nameArray {
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@", [dateStart, dateEnd])
            let filteredArray = allWorkouts.filter(predicateDifference).sorted(byKeyPath: "workoutDate")
            workoutArray = filteredArray.map{ $0 }
            
            guard let last = workoutArray.last?.workoutReps,
                    let first = workoutArray.first?.workoutReps
            else {
                return
            }
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: last, firstReps: first)
            differenceArray.append(differenceWorkout)
        }
        exercisesTableView.setDifferenceArray(array: differenceArray)
    }
    
    private func setStartScreen(){
        let dateToday = Date()
        differenceArray = [DifferenceWorkout]()
        getDifferenceModel(dateStart: dateToday.offsetDays(day: 7))
        exercisesTableView.reloadData()
    }
    
    
//MARK: - objc
    @objc private func segmentedChange(){
        let dateToday = Date()
        differenceArray = [DifferenceWorkout]()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let dateStart = dateToday.offsetDays(day: 7)
            getDifferenceModel(dateStart: dateStart)
        } else {
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
        }
        exercisesTableView.reloadData()
    }

}

//MARK: - Extensions
extension StatisticViewController {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exercisesLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exercisesTableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            exercisesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            exercisesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            exercisesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}
