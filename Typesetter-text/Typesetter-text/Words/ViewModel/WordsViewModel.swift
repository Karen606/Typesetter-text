//
//  WordsViewModel.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 20.09.24.
//

import Foundation

class WordsViewModel {
    static let shared = WordsViewModel()
    @Published var wordPrice: Double?
    @Published var price: String?
    @Published var wordsCount: Int = 0
    @Published var text: String?
    var totalPrice: Double?
    private init() {}
    
    func setText(text: String?) {
        self.text = text
        self.wordsCount = wordCount()
        self.price = self.calculatePrice()
    }
    
    private func wordCount() -> Int {
        guard let text = text else { return 0}
        let value = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = value.components(separatedBy: CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters))
        let validWords = words.filter { !$0.isEmpty }
        return validWords.count
    }
    
    func calculatePrice() -> String {
        guard let wordPrice = wordPrice else { return "0" }
        let sum = wordPrice * Double(wordsCount)
        self.totalPrice = sum
        if Double(Int(sum)) == sum {
            return "\(Int(sum))"
        } else {
            return "\(sum)"
        }
    }
    
    func saveProject(completion: @escaping (Bool) -> Void) {
        guard let price = totalPrice else {
            completion(false)
            return
        }
        CoreDataManager.shared.saveText(textModel: TextModel(price: price, words: Int32(wordsCount), wordPrice: wordPrice ?? 0)) { success in
            completion(success)
        }
    }
    
    func saveText(completion: @escaping (Bool) -> Void) {
        guard let text = text, !text.isEmpty, let wordPrice = wordPrice else {
            completion(true)
            return
        }
        CoreDataManager.shared.saveWork(workModel: WorkModel(work: text, price: wordPrice)) { success in
            completion(success)
        }
    }
    
    func setWork(work: WorkModel) {
        self.wordPrice = work.price
        self.text = work.work
    }
    
    func removeWork() {
        CoreDataManager.shared.removeWork()
    }
    
    func clear() {
        wordPrice = nil
        text = nil
        price = nil
        wordsCount = 0
    }
}
