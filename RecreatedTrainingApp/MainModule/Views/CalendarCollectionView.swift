//
//  CalendarCollectionView.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 21.06.2023.
//

import UIKit

protocol CalendarViewProtocol: AnyObject {
    func selectItem(date: Date)
}

class CalendarCollectionView: UICollectionView {
    
    weak var calendarDelegate: CalendarViewProtocol?
    
    private let collectionLayout = UICollectionViewFlowLayout()
    
    private let idCalendarCell = "idCalendarCell"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionLayout)
        
        configure()
        setupLayout()
        setDelegate()
        register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: idCalendarCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        collectionLayout.minimumInteritemSpacing = 3
    }
    
    private func configure(){
        backgroundColor = .none
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegate(){
        dataSource = self
        delegate = self
    }
}

extension CalendarCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCalendarCell, for: indexPath) as?
                CalendarCollectionViewCell else {
            return UICollectionViewCell()
        }
        let dateTimeZone = Date()
        let weekArray = dateTimeZone.getWeekArray()
        cell.dateForCell(numberOfDay: weekArray[1][indexPath.row], dayOfWeek: weekArray[0][indexPath.row])
        
        if indexPath.item == 6 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        }
        return cell
    }
}

extension CalendarCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapppppppp", indexPath)
        let dateTimeZone = Date()
        let date = dateTimeZone.offsetDays(day: 6 - indexPath.item)
        calendarDelegate?.selectItem(date: date)
    }
}

extension CalendarCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 8, height: collectionView.frame.height)
    }
}
