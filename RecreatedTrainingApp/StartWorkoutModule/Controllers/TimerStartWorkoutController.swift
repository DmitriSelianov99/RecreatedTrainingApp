//
//  TimerStartWorkoutController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 18.07.2023.
//

import UIKit

class TimerStartWorkoutController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setConstraints()
        addTaps()
        setDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        animationCircular()
    }
   
//MARK: - Elements
    private let headerLabel = UILabel(text: "START WORKOUT", font: .robotoMedium24() ?? .systemFont(ofSize: 24), textColor: .specialGray)
    private let closeButton = CloseButton()
    
    
    private let timerCircleView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timer")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let timerClock = UILabel(text: "1:40", font: .robotoBold48() ?? .systemFont(ofSize: 48), textColor: .specialGray)
    
    private let detailsView = DetailsView(typeOfRepeats: "Time of set", quantityOfRepeats: "1 min 30 sec")
    
    private lazy var finishButton = UserButton(text: "FINISH", color: .specialGreen)
    
    private var workoutModel = WorkoutModel()
    private var customAlert: CustomAlert?
    private let shapeLayer = CAShapeLayer() //зеленая полоска
    
    private var durationTimer = 10
    private var numberOfSet = 1

//MARK: - Functions
    private func setupViews(){
        view.backgroundColor = .specialBackground
        
        view.addSubview(headerLabel)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        view.addSubview(timerCircleView)
        view.addSubview(timerClock)
        detailsView.refreshLabels(model: workoutModel, numberOfSet: numberOfSet)
        view.addSubview(detailsView)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        view.addSubview(finishButton)
    }
    
    private func addTaps(){
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerClock.isUserInteractionEnabled = true //обработка пользовательских действий
        timerClock.addGestureRecognizer(tapLabel)
    }
    
    public func setWorkoutModel(model: WorkoutModel){
        workoutModel = model
    }
    
    private func setDelegates(){
        detailsView.cellNextSetDelegate = self
    }
    
//MARK: - objc
    @objc private func startTimer(){
        print("go")
        basicANimation()
    }
    
    @objc private func closeButtonTapped(){
        print("close")
        self.dismiss(animated: true, completion: nil)
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


//MARK: - NextSetProtocol

extension TimerStartWorkoutController: NextSetProtocol {
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
        customAlert?.presentCustomAlert(viewController: self, repsOrTimer: "Timer") { [weak self] sets, timer in
            print(timer, sets)
            guard let self = self else { return }
            if sets != "" && timer != "" {
                guard let numberOfSets = Int(sets),
                      let numberOfTimer = Int(timer) else { return }
                RealmManager.shared.updateSetsTimerWorkoutModel(model: self.workoutModel,
                                                               sets: numberOfSets,
                                                               timer: numberOfTimer)
                self.detailsView.refreshLabels(model: self.workoutModel, numberOfSet: self.numberOfSet)
            }
            self.customAlert = nil
        }
        print("Это выводится еще до работы presentCustomAlert")

    }
}

//MARK: - Extension
extension TimerStartWorkoutController {
    private func animationCircular(){
        let center = CGPoint(x: timerCircleView.frame.width / 2, y: timerCircleView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        //рисуем линию
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 113,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 19
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round //закругление концов
        timerCircleView.layer.addSublayer(shapeLayer)
    }
    
    private func basicANimation(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

//MARK: - Constraints
extension TimerStartWorkoutController {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            timerCircleView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            timerCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerCircleView.heightAnchor.constraint(equalToConstant: 240),
            timerCircleView.widthAnchor.constraint(equalToConstant: 240),
            
            timerClock.centerYAnchor.constraint(equalTo: timerCircleView.centerYAnchor),
            timerClock.centerXAnchor.constraint(equalTo: timerCircleView.centerXAnchor),
            
            detailsView.topAnchor.constraint(equalTo: timerCircleView.bottomAnchor, constant: 25),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            detailsView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
            
            finishButton.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 15),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            finishButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}
