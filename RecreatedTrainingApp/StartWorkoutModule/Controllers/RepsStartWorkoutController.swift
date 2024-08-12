//
//  RepsStartWorkoutController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 16.07.2023.
//

import UIKit

class RepsStartWorkoutController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private let headerLabel = UILabel(text: "START WORKOUT", font: .robotoMedium24() ?? .systemFont(ofSize: 24), textColor: .specialGray)
    private let closeButton = CloseButton()
    private var workoutModel = WorkoutModel()
    
    private var numberOfSet = 1
    
    private var customAlert: CustomAlert?
    
    private let girlImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "girl")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let detailsView = DetailsView(typeOfRepeats: "Reps", quantityOfRepeats: "20")
    
    private lazy var finishButton = UserButton(text: "FINISH", color: .specialGreen)
//MARK: - Functions
    private func setupViews(){
        view.backgroundColor = .specialBackground
        
        view.addSubview(headerLabel)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        view.addSubview(girlImageView)
        detailsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        view.addSubview(detailsView)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        view.addSubview(finishButton)
    }
    
    public func setWorkoutModel(model: WorkoutModel){
        workoutModel = model
    }
    
    private func setDelegates(){
        detailsView.cellNextSetDelegate = self
    }
    
//MARK: - objc
    @objc private func closeButtonTapped(){
        print("close")
        dismiss(animated: true, completion: {() -> Void in
            print("completition clousre")
        })
    }
    
    @objc private func finishButtonTapped(){
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel)
        } else {
            presentAlert(title: "Warning", message: "You haven't finished your workout") {
                self.dismiss(animated: true)
            }
        }
    }
}

//MARK: - Extension

extension RepsStartWorkoutController: NextSetProtocol {
    func nextSetTapped() {
        print("n e x t")
        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            detailsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        } else {
            presentSimpleAlert(title: "Ошибка!", message: "Это последний подход. Нажмите FINISH для завершения тренировки")
        }
    }
    
    func editingTapped() {
        customAlert = CustomAlert()
        customAlert?.presentCustomAlert(viewController: self, repsOrTimer: "Reps") { [weak self] sets, reps in
            print(reps, sets)
            guard let self = self else { return }
            if sets != "" && reps != "" {
                guard let numberOfSets = Int(sets),
                      let numberOfReps = Int(reps) else { return }
                RealmManager.shared.updateSetsRepsWorkoutModel(model: self.workoutModel,
                                                               sets: numberOfSets,
                                                               reps: numberOfReps)
                self.detailsView.refreshLabels(model: self.workoutModel, numberOfSet: self.numberOfSet)
            }
            self.customAlert = nil
        }
        print("Это выводится еще до работы presentCustomAlert")

    }
    
    
}

extension RepsStartWorkoutController {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            girlImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            girlImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            girlImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            girlImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            detailsView.topAnchor.constraint(equalTo: girlImageView.bottomAnchor, constant: 25),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            detailsView.heightAnchor.constraint(equalToConstant: 250),
            
            finishButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 15),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            finishButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}
