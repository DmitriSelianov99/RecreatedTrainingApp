//
//  EditingProfileController.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 02.08.2023.
//

import UIKit
import PhotosUI

class EditingProfileController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVeiws()
        setConstraints()
        addGesture()
        loadUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
    
    private let editingLabel: UILabel = {
        let label = UILabel()
        label.text = "EDITING PROFILE"
        label.font = .robotoMedium24()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton = CloseButton()
    
    private var userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8044065833, green: 0.8044064641, blue: 0.8044064641, alpha: 1)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.image = UIImage(named: "addPhoto")
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let greenView: UIView = {
       let greenView = UIView()
        greenView.backgroundColor = .specialGreen
        greenView.layer.cornerRadius = 10
        greenView.translatesAutoresizingMaskIntoConstraints = false
        return greenView
    }()
    
//MARK: - Поля для ввода
    
    private var generalStackView = UIStackView()
    
    private let nameLabel = UILabel(text: "Name")
    private let nameTextField = BrownTextField()
    private var nameStackView = UIStackView()
    
    private let surnameLabel = UILabel(text: "Surname")
    private let surnameTextField = BrownTextField()
    private var surnameStackView = UIStackView()
    
    private let heightLabel = UILabel(text: "Height")
    private let heightTextField = BrownTextField()
    private var heightStackView = UIStackView()
    
    private let weightLabel = UILabel(text: "Weight")
    private let weightTextField = BrownTextField()
    private var weightStackView = UIStackView()
    
    private let targetLabel = UILabel(text: "Target")
    private let targetTextField = BrownTextField()
    private var targetStackView = UIStackView()
    
    private let saveButton = UserButton(text: "SAVE", color: .specialGreen)
    
    private var userModel = UserModel()
  
//MARK: - FUNCTIONS
    private func setupVeiws(){
        view.backgroundColor = .specialBackground
        view.addSubview(editingLabel)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        view.addSubview(greenView)
        view.addSubview(userPhotoImageView)
        nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField], axis: .vertical, spacing: 3)
        surnameStackView = UIStackView(arrangedSubviews: [surnameLabel, surnameTextField], axis: .vertical, spacing: 3)
        heightStackView = UIStackView(arrangedSubviews: [heightLabel, heightTextField], axis: .vertical, spacing: 3)
        weightStackView = UIStackView(arrangedSubviews: [weightLabel, weightTextField], axis: .vertical, spacing: 3)
        targetStackView = UIStackView(arrangedSubviews: [targetLabel, targetTextField], axis: .vertical, spacing: 3)

        generalStackView = UIStackView(arrangedSubviews: [nameStackView, surnameStackView, heightStackView, weightStackView, targetStackView],
                                       axis: .vertical,
                                       spacing: 20)
        view.addSubview(generalStackView)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    private func addGesture(){
        //при нажатии куда-нибудь пропадает фокус с поля
//        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        view.addGestureRecognizer(tapScreen)
//        tapScreen.cancelsTouchesInView = false
        
        let tapImageView = UITapGestureRecognizer(target: self, action: #selector(setUserPhoto))
        userPhotoImageView.isUserInteractionEnabled = true
        userPhotoImageView.addGestureRecognizer(tapImageView)
        //tapImageView.cancelsTouchesInView = false
    }
    
    private func setUserModel() {
        guard let firstName = nameTextField.text,
              let secondName = surnameTextField.text,
              let height = heightTextField.text,
              let weight = weightTextField.text,
              let target = targetTextField.text
        else { return }
        
        guard let intWeight = Int(weight),
              let intHeight = Int(height),
              let intTarget = Int(target)
        else { return }
        
        userModel.userFirstName = firstName
        userModel.userSecondName = secondName
        userModel.userHeight = intHeight
        userModel.userWeight = intWeight
        userModel.userTarget = intTarget
        
        if userPhotoImageView.image == UIImage(named: "addPhoto") {
            userModel.userImage = nil
        } else {
//            guard let imageData = userPhotoImageView.image?.pngData() else { return }
//            userModel.userImage = imageData
            guard let image = userPhotoImageView.image else { return }
            let jpegData = image.jpegData(compressionQuality: 1) //сжимаем картинку
            userModel.userImage = jpegData
        }
    }
    
    private func loadUserInfo(){
        let userArray = RealmManager.shared.getResultUserModel()
        
        if userArray.count != 0 {
            nameTextField.text = userArray[0].userFirstName
            surnameTextField.text = userArray[0].userSecondName
            heightTextField.text = "\(userArray[0].userHeight)"
            weightTextField.text = "\(userArray[0].userWeight)"
            targetTextField.text = "\(userArray[0].userTarget)"
            
            guard let data = userArray[0].userImage,
                  let image = UIImage(data: data)
            else { return }
            userPhotoImageView.image = image
            userPhotoImageView.contentMode = .scaleAspectFit
        }
    }
 
//MARK: - @objc
    @objc private func setUserPhoto(){
        print("photo")
        alertPhotoOrCamera { [weak self] source in
            guard let self = self else { return }
            
            if #available(iOS 14, *) {
                self.presentImagePicker()
            } else {
                self.chooseImagePicker(source: source)
            }
            
            
        }
    }
    
    @objc private func saveButtonTapped(){
        print("check")
        setUserModel()
        
        let userArray = RealmManager.shared.getResultUserModel()
        
        if userArray.count == 0 {
            RealmManager.shared.saveUserModel(userModel)
        } else {
            RealmManager.shared.updateUserModel(model: userModel)
        }
        userModel = UserModel()
    }
    
    @objc private func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func closeButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - EXTENSIONS
extension EditingProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImagePicker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        userPhotoImageView.image = image
        userPhotoImageView.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
}

@available(iOS 14, *)
extension EditingProfileController:PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.userPhotoImageView.image = image
                    self.userPhotoImageView.contentMode = .scaleAspectFit
                }
                
            }
        }
    }
    
    private func presentImagePicker(){
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images])
        
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
    
}

//MARK: - Constaints
extension EditingProfileController {
    private func setConstraints(){
        NSLayoutConstraint.activate([
            editingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            editingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            closeButton.centerYAnchor.constraint(equalTo: editingLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 33),
            closeButton.widthAnchor.constraint(equalToConstant: 33),
            
            userPhotoImageView.topAnchor.constraint(equalTo: editingLabel.bottomAnchor, constant: 20),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            greenView.topAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            greenView.heightAnchor.constraint(equalToConstant: 70),
            greenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            greenView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            heightTextField.heightAnchor.constraint(equalToConstant: 40),
            weightTextField.heightAnchor.constraint(equalToConstant: 40),
            targetTextField.heightAnchor.constraint(equalToConstant: 40),
            
            generalStackView.topAnchor.constraint(equalTo: greenView.bottomAnchor, constant: 40),
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            saveButton.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 345),
            saveButton.heightAnchor.constraint(equalToConstant: 55),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

