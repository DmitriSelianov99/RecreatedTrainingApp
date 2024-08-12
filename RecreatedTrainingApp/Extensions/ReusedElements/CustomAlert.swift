//
//  CustomAlert.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 22.07.2023.
//

import UIKit

//class CustomAlert: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

//MARK: ДЕЛАЕМ НА ФРЕЙМАХ
class CustomAlert {
    private let backgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private var mainView: UIView?
    
    private let setsTextField = BrownTextField()
    private let repsTextField = BrownTextField()
    
    private var buttonAction: ((String, String) -> Void)?
    
    func presentCustomAlert(viewController: UIViewController,
                            repsOrTimer: String,
                            completion: @escaping (String, String) -> Void){
        
        registerKeyboardNotification()
        
        guard let parentView = viewController.view else { return }
        mainView = parentView
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        backgroundView.frame = parentView.frame
        scrollView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 40,
                                 y: -420,
                                 width: parentView.frame.width - 80,
                                 height: 420)
        scrollView.addSubview(alertView)
        
        //MARK: sportsmanImageView
        let sportsmanImageView = UIImageView(frame: CGRect( x: Int(alertView.frame.width - alertView.frame.height * 0.4) / 2,
                                                            y: 30,
                                                            width: Int(alertView.frame.height * 0.4),
                                                            height: Int(alertView.frame.height * 0.4)
                                                          )
        )
        sportsmanImageView.image = UIImage(named: "sportsman")
        sportsmanImageView.contentMode = .scaleAspectFit
        alertView.addSubview(sportsmanImageView)
        
        //MARK: editingLabel
        let editingLabel = UILabel(text: "Editing", font: .robotoMedium22()!, textColor: .specialBlack)
        editingLabel.frame = CGRect(x: 10,
                                    y: Int(alertView.frame.height * 0.4) + 50,
                                    width: Int(alertView.frame.width) - 20,
                                    height: 20)
        editingLabel.textAlignment = .center
        editingLabel.translatesAutoresizingMaskIntoConstraints = true
        alertView.addSubview(editingLabel)
        
        //MARK: setsLabel
        let setsLabel = UILabel(text: "Sets")
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        setsLabel.frame = CGRect(x: 30,
                                 y: Int(editingLabel.frame.maxY) + 10,
                                 width: Int(alertView.frame.width) - 60,
                                 height: 20)
        alertView.addSubview(setsLabel)
        
        //MARK: setsTextField
        setsTextField.frame = CGRect(x: 20,
                                     y: Int(setsLabel.frame.maxY),
                                     width: Int(alertView.frame.width) - 40,
                                     height: 30)
        setsTextField.translatesAutoresizingMaskIntoConstraints = true
        setsTextField.keyboardType = .numberPad
        alertView.addSubview(setsTextField)
        
        //MARK: repsOrTimerLabel
        let repsOrTimerLabel = UILabel(text: repsOrTimer)
        repsOrTimerLabel.translatesAutoresizingMaskIntoConstraints = true
        repsOrTimerLabel.frame = CGRect(x: 30,
                                 y: Int(setsTextField.frame.maxY) + 10,
                                 width: Int(alertView.frame.width) - 60,
                                 height: 20)
        alertView.addSubview(repsOrTimerLabel)
        
        //MARK: repsTextField
        repsTextField.frame = CGRect(x: 20,
                                     y: Int(repsOrTimerLabel.frame.maxY),
                                     width: Int(alertView.frame.width) - 40,
                                     height: 30)
        repsTextField.translatesAutoresizingMaskIntoConstraints = true
        repsTextField.keyboardType = .numberPad
        alertView.addSubview(repsTextField)
        
        //MARK: okButton
        let okButton = UserButton(text: "OK", color: .specialGreen)
        okButton.frame = CGRect(x: 50,
                                y: Int(repsTextField.frame.maxY) + 15,
                                width: Int(alertView.frame.width) - 100,
                                height: 35)
        okButton.translatesAutoresizingMaskIntoConstraints = true
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        buttonAction = completion
        
        
        //MARK: - Animation
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in //по завершению анимации - когда анимация закончилась. Изначально FALSE
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }

    }
    
    //MARK: - Register KeyboardNotification
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //MARK: - Remove KeyboardNotification
    private func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    //MARK: - objc
    @objc private func kbWillShow(){
        scrollView.contentOffset = CGPoint(x: 0, y: 100)
    }
    
    @objc private func kbWillHide(){
        scrollView.contentOffset = CGPoint.zero
    }
    
    @objc private func okButtonTapped(){
        print("O K")
        guard let setNumber = setsTextField.text,
              let repsNumber = repsTextField.text
        else { return }
        
        buttonAction?(setNumber, repsNumber)
        
        guard let targetView = mainView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40,
                                          y: Int(targetView.frame.height),
                                          width: Int(targetView.frame.width) - 80,
                                          height: 420)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 0
            } completion: { done in
                if done {
                    self.alertView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    self.scrollView.removeFromSuperview()
                    self.setsTextField.text = ""
                    self.repsTextField.text = ""
                    self.removeKeyboardNotification()
                }
            }

        }

    }
    
    
}
