//
//  ProjectsModel.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import Foundation


struct ProjectModel {
    var texts: [TextModel]
}

struct TextModel {
    var price: Double
    var words: Int32
    var wordPrice: Double
}
