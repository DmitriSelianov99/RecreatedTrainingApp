//
//  MainTableView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 24.06.2023.
//

import UIKit

protocol MainTableViewProtocol: AnyObject {
    func deleteWorkout(model: WorkoutModel, index: Int)
}

class MainTableView: UITableView {
    
    weak var mainDelegate: MainTableViewProtocol?
    
    private var workoutArray = [WorkoutModel]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        setDelegates()
        register(WorkoutTableViewCell.self, forCellReuseIdentifier: WorkoutTableViewCell.idTableViewCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = .none
        separatorStyle = .none
        bounces = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegates(){
        delegate = self
        dataSource = self
    }
    
    public func setWorkoutArray(array: [WorkoutModel]){
        workoutArray = array
    }
}

//MARK: - Extension
extension MainTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.idTableViewCell, for: indexPath) as?
                WorkoutTableViewCell else {
            return UITableViewCell()
        }
        
        let workoutModel = workoutArray[indexPath.row]
        cell.configure(model: workoutModel)
        cell.workoutCelDelegate = mainDelegate as? WorkoutCellProtocol
        return cell
    }
}


extension MainTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        105
    }
    
    //MARK: левый свайп, просто для тестирования
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action2 = UIContextualAction(style: .destructive, title: "") { [weak self]  _, _, _ in
            guard let self = self else { return }
            let deleteModel = self.workoutArray[indexPath.row]
            self.mainDelegate?.deleteWorkout(model: deleteModel, index: indexPath.row)
            
        }
        
        action2.backgroundColor = .specialBackground
        action2.image = UIImage(named: "delete")
        
        return UISwipeActionsConfiguration(actions: [action2])
    }
    
    //MARK: правый свайп
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "") { [weak self]  _, _, _ in
            guard let self = self else { return }
            let deleteModel = self.workoutArray[indexPath.row]
            self.mainDelegate?.deleteWorkout(model: deleteModel, index: indexPath.row)
            
        }
        
        action.backgroundColor = .specialBackground
        action.image = UIImage(named: "delete")
        
        
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

