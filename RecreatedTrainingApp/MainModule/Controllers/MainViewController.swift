//
//  ViewController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 20.06.2023.
//

import UIKit

class MainViewController: UIViewController {
 
//MARK: - Elements
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
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Dmitri Selianov"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("Add workout", for: .normal)
        button.tintColor = .specialDarkGreen
        button.titleLabel?.font = .robotoMedium12()
        button.imageEdgeInsets = .init(top: 0,
                                       left: 20,
                                       bottom: 15,
                                       right: 0)
        button.titleEdgeInsets = .init(top: 50,
                                       left: -40,
                                       bottom: 0,
                                       right: 0)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addShadowOnView()
        button.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noWorkoutImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noWorkout")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    private let workoutTodayLabel = UILabel(text: "Workout today")
    private let tableView = MainTableView()
    
    private var workoutArray = [WorkoutModel]()

//MARK: - Functions
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectItem(date: Date())
        setupUserParameters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showOnboarding()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        
        getWeather()
    }
    
    private func setupViews(){
        view.backgroundColor = .specialBackground
        
        view.addSubview(userPhotoImageView)
        view.addSubview(calendarView)
        calendarView.setDelegate(self)//пробрасываем делегата через вьюху
        view.sendSubviewToBack(calendarView) //отправляем зеленый назад
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutTodayLabel)
        tableView.mainDelegate = self
        view.addSubview(tableView)
        view.addSubview(noWorkoutImageView)
    }
    
    private func getWorkouts(date: Date) {
        let weekday = date.getWeekdayNumber()
        let dayStart = date.startEndDate().start
        let dayEnd = date.startEndDate().end
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateNoRepeat = NSPredicate(format: "workoutRepeat = false AND workoutDate BETWEEN %@", [dayStart, dayEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateNoRepeat])
        
        let resultArray = RealmManager.shared.getResultWorkoutModel()
        let filteredArray = resultArray.filter(compound).sorted(byKeyPath: "workoutName")
        
        workoutArray = filteredArray.map{ $0 }
    }
    
    private func checkWorkoutToday(){
        if workoutArray.count == 0 {
            noWorkoutImageView.isHidden = false
            tableView.isHidden = true
        } else {
            noWorkoutImageView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setupUserParameters(){
        let userArray = RealmManager.shared.getResultUserModel()
        
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + " " + userArray[0].userSecondName
//            weightLabel.text = "Height: \(userArray[0].userWeight)"
//            heightLabel.text = "Weight: \(userArray[0].userHeight)"
//            targetView.targetLabel.text = "TARGET: \(userArray[0].userTarget)"
//            targetView.targetToLabel.text = "\(userArray[0].userTarget)"
            
            guard let data = userArray[0].userImage,
                  let image = UIImage(data: data)
            else { return }
            userPhotoImageView.image = image
        }
    }
    
    private func getWeather() {
        NetworkDataFetch.shared.fetchWeather { [weak self] result, error in
            guard let self = self else { return}
            if let model = result {
                print(model)
                self.weatherView.updateLabels(model: model)
                NetworkImageRequest.shared.requestImageData(id: model.weather[0].icon) { result in
                    switch result {
                    case .success(let data):
                        self.weatherView.updateImage(data: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showOnboarding(){
        let userDefaults = UserDefaults.standard
        let onBoardingWasViewed = userDefaults.bool(forKey: "OnBoardingWasViewed")
        if onBoardingWasViewed == false {
            let onboardingVC = OnboardingViewController()
            onboardingVC.modalPresentationStyle = .fullScreen
            present(onboardingVC, animated: true)
        }
    }
    
//MARK: - objc
    @objc private func addWorkoutButtonTapped(){
        let newWorkoutVieWController = NewWorkoutViewController()
        newWorkoutVieWController.modalPresentationStyle = .fullScreen
        present(newWorkoutVieWController, animated: true)
    }
}

//MARK: - Extensions

extension MainViewController: WorkoutCellProtocol {
    func startButtonTapped(model: WorkoutModel) {
        if model.workoutTimer == 0 {
            print("reps")
            let repsStartWorkoutController = RepsStartWorkoutController()
            repsStartWorkoutController.modalPresentationStyle = .fullScreen
            repsStartWorkoutController.setWorkoutModel(model: model)
            present(repsStartWorkoutController, animated: true)
        } else {
            print("timer")
            let timerStartWorkoutController = TimerStartWorkoutController()
            timerStartWorkoutController.modalPresentationStyle = .fullScreen
            timerStartWorkoutController.setWorkoutModel(model: model)
            present(timerStartWorkoutController, animated: true)
        }
    }
}

extension MainViewController: CalendarViewProtocol {
    func selectItem(date: Date) {
        getWorkouts(date: date)
        tableView.setWorkoutArray(array: workoutArray)
        tableView.reloadData()
        checkWorkoutToday()
    }
}

extension MainViewController: MainTableViewProtocol {
    func deleteWorkout(model: WorkoutModel, index: Int) {
        RealmManager.shared.deleteWorkoutModel(model)
        workoutArray.remove(at: index)
        tableView.setWorkoutArray(array: workoutArray)
        tableView.reloadData()
    }
}

extension MainViewController {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            calendarView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),
            
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherView.heightAnchor.constraint(equalToConstant: 80),
            
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 15),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            workoutTodayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            noWorkoutImageView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            noWorkoutImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noWorkoutImageView.heightAnchor.constraint(equalTo: noWorkoutImageView.widthAnchor, multiplier: 1)
        ])
    }
}

