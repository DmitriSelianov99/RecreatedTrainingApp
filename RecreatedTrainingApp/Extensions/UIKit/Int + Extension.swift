//
//  Int + Extension.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 12.07.2023.
//

import Foundation

extension Int {
    func getTimeFromSecond() -> String {
        
        if self / 60 == 0 {
            return "\(self % 60) sec"
        }
        
        if self % 60 == 0 {
            return "\(self / 60) min"
        }
        
         return "\(self / 60) min \(self % 60) sec"
    }
    
    func convertSeconds() -> (Int, Int) {
        let min = self / 60
        let sec = self % 60
        return (min, sec)
    }
    
    func setZeroForSeconds() -> String {
        Double(self) / 10.0 < 1 ? "0\(self)" : "\(self)"
    }
}
