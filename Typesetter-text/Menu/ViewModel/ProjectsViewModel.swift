//
//  ProjectsViewModel.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import Foundation

class ProjectsViewModel {
    static let shared = ProjectsViewModel()
    @Published var price: Double = 0
    @Published var words: Int32 = 0
    var work: WorkModel?
    
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchTexts { [weak self] textModels in
            guard let self = self else { return }
            self.price = textModels.compactMap { $0.price }.reduce(0, +)
            self.words = textModels.compactMap { $0.words }.reduce(0, +)
        }
        
        CoreDataManager.shared.fetchWork { [weak self] work in
            guard let self = self else { return }
            self.work = work
        }
    }
    
}
