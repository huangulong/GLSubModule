//
//  GLCoreDataManager.swift
//  GLLibSwift
//
//  Created by huanggulong on 2021/8/9.
//  Copyright © 2021 历山大亚. All rights reserved.
//

import CoreData


/* Example (User List)
 func modifyUserData() {
     GLCoreDataManager.shared.modifyData(with: "User") { user in
         if let u = user as? User {
             u.age = 32
         }
     }
 }
 
 func addUserData() {
     GLCoreDataManager.shared.addData(with: "User") { user in
         if let u = user as? User {
             u.age = 25
             u.name = "huanggujin"
             u.id = 3
         }
     }
 }
 
 func deleteUser() {
     GLCoreDataManager.shared.deleteData(with: "User", predicate: "id = 1")
 }
 
 func fetchUserData() {
     let m = GLCoreDataManager.shared.fetchData(with: "User", offset: 1)
     if let data = m as? [User] {
         for u in data {
             print("person data id=\(u.id) name=\(u.name ?? "")\tage\(u.age)")
         }
     }
 }
 */
/*
 coreData的操作
 */
class GLCoreDataManager: NSObject {

    static let shared: GLCoreDataManager = GLCoreDataManager()
    
    //xcdatamodel 的name
    public var dbName: String = "Model"
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: self.dbName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    ///保存修改的内容
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// 添加一条实体数据
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - completion: 在闭包中做属性的填充
    func addData(with entityName: String, completion: (NSManagedObject)->Void) {
        let context = self.persistentContainer.viewContext
        
        let model = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        completion(model)
        saveContext()
    }
    
    
    /// 创建一条实体数据
    /// - Parameter entityName: 实体名称
    /// - Returns: NSManagedObject实例
    func createData(with entityName: String) -> NSManagedObject {
        let context = self.persistentContainer.viewContext
        
        let model = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        return model
    }
    
    /// 根据条件删除相应的实体数据
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - predicate: 谓词正则(String)
    func deleteData(with entityName: String, predicate: String) {
        let predicate2 = NSPredicate(format: predicate, "")
        deleteData(with: entityName, predicate: predicate2)
        addData(with: "") { ent in
            
        }
    }
    
    /// 根据条件删除相应的实体数据
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - predicate: 谓词正则(NSPredicate)
    func deleteData(with entityName: String, predicate: NSPredicate? = nil) {
        let context = self.persistentContainer.viewContext
        let m = self.fetchData(with: entityName, limit: Int.max, offset: 0, predicate: predicate) as? [NSManagedObject]
        guard let array = m else { return }
        for info in array {
            context.delete(info)
        }
        saveContext()
    }
    
    /// 获取相应条件下的所有数据列表
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - limit: 每页的大小
    ///   - offset: 页码的偏移量
    ///   - predicate: 谓词正则(String)
    /// - Returns: 模型列表
    func fetchData(with entityName: String, limit: Int = 20, offset: Int = 0, predicate: String) -> [Any]?{
        let predicate2 = NSPredicate(format: predicate, "")
        return self.fetchData(with: entityName, limit: limit, offset: offset, predicate: predicate2)
    }
    
    
    /// 获取相应条件下的所有数据列表
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - limit: 每页的大小
    ///   - offset: 页码的偏移量
    ///   - predicate: 谓词正则(NSPredicate)
    /// - Returns: 模型列表
    func fetchData(with entityName: String, limit: Int = 20, offset: Int = 0, predicate: NSPredicate? = nil) -> [Any]? {
        let context = self.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.fetchOffset = offset
        request.fetchLimit = limit
        if let p = predicate {
            request.predicate = p
        }
        do {
            let fetchObjects = try context.fetch(request)
            return fetchObjects
        } catch {
            return nil
        }
    }
    
    /// 获取相应条件下的第一条数据列表
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - predicate: 谓词正则(NSPredicate)
    /// - Returns: 第一条数据对象
    func fetchOne(with entityName: String, predicate: NSPredicate? = nil) -> Any? {
        return self.fetchData(with: entityName, limit: 1, offset: 0, predicate: predicate)?.first
    }
    
    
    /// 获取相应条件下的第一条数据列表
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - predicate: 谓词正则(String)
    /// - Returns: 第一条数据对象
    func fetchOne(with entityName: String, predicate: String) -> Any? {
        return self.fetchData(with: entityName, limit: 1, offset: 0, predicate: predicate)?.first
    }
    
    /// 修改数据
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - predicate: 谓词正则(NSPredicate)
    ///   - completion: 在闭包中做相应的修改
    func modifyData(with entityName: String, predicate: NSPredicate? = nil, completion: (NSManagedObject)->Void) {
        let m = self.fetchData(with: entityName, limit: Int.max, offset: 0, predicate: predicate) as? [NSManagedObject]
        guard let array = m else { return }
        for info in array {
            completion(info)
        }
        saveContext()
    }
    
    /// 修改数据
    /// - Parameters:
    ///   - entityName: 实体名称
    ///   - predicate: 谓词正则(String)
    ///   - completion: 在闭包中做相应的修改
    func modifyData(with entityName: String, predicate: String, completion: (NSManagedObject)->Void) {
        let predicate2 = NSPredicate(format: predicate, "")
        modifyData(with: entityName, predicate: predicate2, completion: completion)
    }
    
}
