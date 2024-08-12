//
//  ExercisesTableView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 29.06.2023.
//

import UIKit

class ExercisesTableView: UITableView {
    
    private var differenceArray = [DifferenceWorkout]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        setDelegates()
        register(ExercisesTableViewCell.self, forCellReuseIdentifier: ExercisesTableViewCell.idTableViewCell)
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
        dataSource = self
        delegate = self
    }
    
    public func setDifferenceArray(array: [DifferenceWorkout]){
        differenceArray = array
    }
}

//MARK: - Extensions
extension ExercisesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        differenceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExercisesTableViewCell.idTableViewCell, for: indexPath) as? ExercisesTableViewCell else {
            return UITableViewCell()
        }
        let model = differenceArray[indexPath.row]
        cell.configure(differenceWorkout: model)
        return cell
    }
}

extension ExercisesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
}
