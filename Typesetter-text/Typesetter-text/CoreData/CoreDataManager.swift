//
//  CoreDataManager.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 19.09.24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    func registerUser(name: String, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { completion(false)
            return
        }
        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            let orderEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
            let order = NSManagedObject(entity: orderEntity, insertInto: managedContext)
            order.setValue(name, forKey: "name")
            do {
                try managedContext.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func saveText(textModel: TextModel, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { completion(false)
            return
        }
        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            let orderEntity = NSEntityDescription.entity(forEntityName: "Text", in: managedContext)!
            let order = NSManagedObject(entity: orderEntity, insertInto: managedContext)
            order.setValue(textModel.price, forKey: "price")
            order.setValue(textModel.words, forKey: "words")
            order.setValue(textModel.wordPrice, forKey: "wordPrice")
            do {
                try managedContext.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func fetchTexts(completion: @escaping ([TextModel]) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion([])
            return
        }
        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Text")
            
            do {
                let fetchedOrders = try managedContext.fetch(fetchRequest)
                var textModels = [TextModel]()
                for text in fetchedOrders {
                    let price = text.value(forKey: "price") as? Double ?? 0
                    let words = text.value(forKey: "words") as? Int32 ?? 0
                    let wordPrice = text.value(forKey: "wordPrice") as? Double ?? 0
                    let textModel = TextModel(price: price, words: words, wordPrice: wordPrice)
                    textModels.append(textModel)
                }
                completion(textModels)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                completion([])
            }
        }
    }
    
    
    func fetchUser(completion: @escaping (UserModel?) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(nil)
            return
        }
        appDelegate.persistentContainer.performBackgroundTask { managedContext in
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.fetchLimit = 1
            do {
                let users = try managedContext.fetch(fetchRequest)
                if let name = users.first?.name {
                    let userModel = UserModel(name: name, photo: users.first?.photo)
                    completion(userModel)
                } else {
                    completion(nil)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                completion(nil)
            }
        }
    }
    
}
