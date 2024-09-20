//
//  UserViewModel.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import Foundation

class UserViewModel {
    static let shared = UserViewModel()
    @Published var name: String?
    @Published var photo: Data?
    private init() {}
    
    func saveUser(completion: @escaping (Bool) -> Void) {
        guard let name = name else { return }
        CoreDataManager.shared.saveUser(name: name, photo: photo, completion: completion)
    }
    
    func getUser() {
        CoreDataManager.shared.fetchUser { userModel in
            self.name = userModel?.name ?? ""
            self.photo = userModel?.photo
        }
    }
    
}
