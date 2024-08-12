//
//  ProfileViewController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 18.07.2023.
//

import UIKit

struct ResultWorkout {
    let name: String
    let result: Int
    let imageData: Data?
}

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutResultCollectionView.setProgressDelegate = self
        setupViews()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workoutResultCollectionView.resultWorkout = [ResultWorkout]()
        workoutResultCollectionView.getWorkoutResults()
        workoutResultCollectionView.reloadData()
        setupUserParameters()
    }
    
    private var resultWorkout = [ResultWorkout]()
    
//MARK: - Elements
    private let headerLabel = UILabel(text: "PROFILE", font: .robotoMedium24() ?? .systemFont(ofSize: 24), textColor: .specialGray)
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        //imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userNameView: UIView = {
        let userNameView = UIView()
        userNameView.backgroundColor = .specialGreen
        userNameView.layer.cornerRadius = 10
        userNameView.translatesAutoresizingMaskIntoConstraints = false
        return userNameView
    }()
    
    private let userNameLabel = UILabel(text: "Dmitri Selianov", font: .robotoBold24() ?? .systemFont(ofSize: 24), textColor: .white)
    
    private let heightLabel = UILabel(text: "Height: 176", font: .robotoBold16() ?? .systemFont(ofSize: 16), textColor: .specialGray)
    private let weightLabel = UILabel(text: "Weight: 74", font: .robotoBold16() ?? .systemFont(ofSize: 16), textColor: .specialGray)
    private var bodyParametersStackView = UIStackView()
    
    private lazy var editingButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.setTitle("Editing", for: .normal)
        btn.titleLabel?.font = .robotoBold16()
        btn.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        btn.tintColor = .specialGreen
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        //переносим картинку справа от текста
        let spacing: CGFloat = 8.0
        //добавить отступ, можно без него
        btn.imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: btn.titleLabel!.frame.size.width + spacing,
                                           bottom: 0,
                                           right: -btn.titleLabel!.frame.size.width)
        btn.semanticContentAttribute = .forceRightToLeft
        
        return btn
    }()
    
    private let workoutResultCollectionView = WorkoutResultsCollectionView()
    private let targetView = TargetView()
    
    
//MARK: - setupViews
    private func setupViews(){
        view.backgroundColor = .specialBackground
        
        view.addSubview(headerLabel)
        view.addSubview(userNameView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        
        bodyParametersStackView = UIStackView(arrangedSubviews: [heightLabel, weightLabel], axis: .horizontal, spacing: 10)
        view.addSubview(bodyParametersStackView)
        
        editingButton.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        view.addSubview(editingButton)
        
        view.addSubview(workoutResultCollectionView)
        
        view.addSubview(targetView)
        
    }
    
//MARK: - FUNCTIONS
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
    
    private func getWorkoutResults(){
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
    
    private func setupUserParameters(){
        let userArray = RealmManager.shared.getResultUserModel()
        
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
            weightLabel.text = "Height: \(userArray[0].userWeight)"
            heightLabel.text = "Weight: \(userArray[0].userHeight)"
            targetView.targetLabel.text = "TARGET: \(userArray[0].userTarget)"
            targetView.targetToLabel.text = "\(userArray[0].userTarget)"
            
            guard let data = userArray[0].userImage,
                  let image = UIImage(data: data)
            else { return }
            userPhotoImageView.image = image
        }
    }
    
//MARK: - objc
    @objc private func editingButtonTapped(){
        print("editing btn")
        let editingProfileController = EditingProfileController()
        editingProfileController.modalPresentationStyle = .fullScreen
        present(editingProfileController, animated: true)
    }
}

//MARK: -
extension ProfileViewController: SetProgressTargetProtocol {
    func setProgress() {
        print("from delegate")
        targetView.progressBarView.setProgress(1, animated: true)
    }
}

//MARK: - Extensions
extension ProfileViewController {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userPhotoImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            userNameView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            userNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            userNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            userNameView.heightAnchor.constraint(equalToConstant: view.frame.height / 8),
            
            userNameLabel.bottomAnchor.constraint(equalTo: userNameView.bottomAnchor, constant: -15),
            userNameLabel.centerXAnchor.constraint(equalTo: userNameView.centerXAnchor),
            
            bodyParametersStackView.topAnchor.constraint(equalTo: userNameView.bottomAnchor, constant: 7),
            bodyParametersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            editingButton.topAnchor.constraint(equalTo: userNameView.bottomAnchor, constant: 7),
            editingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            workoutResultCollectionView.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 25),
            workoutResultCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            workoutResultCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            workoutResultCollectionView.heightAnchor.constraint(equalToConstant: 230),
            
            targetView.topAnchor.constraint(equalTo: workoutResultCollectionView.bottomAnchor, constant: 25),
            targetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            targetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }
}
