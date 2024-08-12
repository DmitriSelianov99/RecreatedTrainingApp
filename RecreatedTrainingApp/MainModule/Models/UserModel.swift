//
//  UserModel.swift
//  RecreatedTrainingApp
//
//  Created by Дмитрий Сельянов on 07.08.2023.
//

import Foundation
import RealmSwift

class UserModel: Object {
    @Persisted var userFirstName: String = "Unknowned name"
    @Persisted var userSecondName: String = "Unknowned surname"
    @Persisted var userHeight: Int = 0
    @Persisted var userWeight: Int = 0
    @Persisted var userTarget: Int = 0
    @Persisted var userImage: Data?
}
