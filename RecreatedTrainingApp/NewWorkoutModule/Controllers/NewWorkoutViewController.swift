//
//  NewWorkoutViewController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 30.06.2023.
//

import UIKit

class NewWorkoutViewController: UIViewController {
    
    private let headerLabel = UILabel(text: "NEW WORKOUT", font: .robotoMedium24()!, textColor: .specialGray)
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let nameView = NameView()
    private let dateAndRepeatView = DateAndRepeatView()
    private let repsOrTimerView = RepsOrTimerView()
    private let iconsCollectionView = IconsCollectionView()
    private let greenButton = UserButton(text: "SAVE", color: .specialGreen)

    private var workoutModel = WorkoutModel()
    private let testImage = UIImage(named: "biceps")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstarints()
        addGesture()
    }
    
    private func setupViews(){
        view.backgroundColor = .specialBackground
        view.addSubview(headerLabel)
        view.addSubview(closeButton)
        view.addSubview(nameView)
        view.addSubview(dateAndRepeatView)
        view.addSubview(repsOrTimerView)
        view.addSubview(iconsCollectionView)
        view.addSubview(greenButton)
        greenButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func setModel(){
        workoutModel.workoutName = nameView.getNameTextField()
        workoutModel.workoutDate = dateAndRepeatView.getDateAndRepeat().date
        workoutModel.workoutRepeat = dateAndRepeatView.getDateAndRepeat().repeatWorkout
        workoutModel.workoutNumberOfDay = dateAndRepeatView.getDateAndRepeat().date.getWeekdayNumber()
        workoutModel.workoutSets = repsOrTimerView.sets
        workoutModel.workoutReps = repsOrTimerView.reps
        workoutModel.workoutTimer = repsOrTimerView.timer
        
        //guard let imageData = testImage?.pngData() else { return }
        let imageData = iconsCollectionView.getImage()
        workoutModel.workoutImage = imageData
    }
    
    private func saveModel(){
        //получаем данные из поля и считаем, есть ли там что-нибудь
        let text = nameView.getNameTextField()
        let count = text.filter { $0.isNumber || $0.isLetter}.count
        
        if count != 0 && workoutModel.workoutSets != 0 && (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0) {
            RealmManager.shared.saveWorkoutModel(workoutModel)
            createNotification()
            presentSimpleAlert(title: "Success", message: "Vsyo zaebis'!")
            workoutModel = WorkoutModel()
            resetValues()
        } else {
            presentSimpleAlert(title: "Error", message: "Some parameters are empty")
        }
    }
    
    private func resetValues(){
        nameView.deleteTextFieldText()
        dateAndRepeatView.resetDateAndRepeat()
        repsOrTimerView.resetSliderViewValues()
    }
    
    //тап по любому участку экрана для скрытия клавиатуры
    private func addGesture(){
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapScreen.cancelsTouchesInView = false //чтобы вернулись все остальные нажатия
        view.addGestureRecognizer(tapScreen)
        
        let swipeScreen = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeScreen)
    }
    
    private func createNotification(){
        let notification = Notifications()
        let stringDate = workoutModel.workoutDate.ddMMyyyyFromDate()
        notification.scheduleDateNotification(date: workoutModel.workoutDate, id: "workout " + stringDate)
    }
    
//MARK: - objc
    @objc private func closeButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped(){
        setModel()
        saveModel()
    }
    
    @objc private func hideKeyboard(){
        view.endEditing(true)
    }
}

//MARK: - Extension
extension NewWorkoutViewController {
    private func setConstarints(){
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            nameView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            nameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            nameView.heightAnchor.constraint(equalToConstant: 60),
            
            dateAndRepeatView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 15),
            dateAndRepeatView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dateAndRepeatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateAndRepeatView.heightAnchor.constraint(equalToConstant: 110),
            
            repsOrTimerView.topAnchor.constraint(equalTo: dateAndRepeatView.bottomAnchor, constant: 20),
            repsOrTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            repsOrTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 295),
            
            iconsCollectionView.topAnchor.constraint(equalTo: repsOrTimerView.bottomAnchor, constant: 25),
            iconsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iconsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iconsCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            greenButton.topAnchor.constraint(equalTo: iconsCollectionView.bottomAnchor, constant: 25),
            greenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            greenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            greenButton.heightAnchor.constraint(equalToConstant: 55)
            
            
//            datePicker.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 10),
//            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//
//            testSwitch.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
//            testSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//
//            testSlider.topAnchor.constraint(equalTo: testSwitch.bottomAnchor, constant: 10),
//            testSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            testSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}
