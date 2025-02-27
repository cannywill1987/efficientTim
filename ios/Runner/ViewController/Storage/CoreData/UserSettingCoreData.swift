////
////  UserSetting.swift
////  Runner
////
////  Created by 林智彬 on 2023/8/23.
////
//
//import Foundation
//import CoreData
//import ManagedSettings
//
//@available(iOS 15.0, *)
//public class UserSettingCoreData: NSManagedObject {
//    @NSManaged public var id: String
//    @NSManaged public var startTime: Date
//    @NSManaged public var endTime: Date
//    @NSManaged public var applicationTokens: Set<ApplicationToken]
//    @NSManaged public var categoriesToken: [ActivityCategoryToken]
//    @NSManaged public var weekend: [Bool]
//
//    func save() {
//        do {
//            try self.managedObjectContext?.save()
//        } catch {
//            print("Failed to save UserSetting: \(error)")
//        }
//    }
//
//    static func load(withID id: String, in context: NSManagedObjectContext) -> UserSetting? {
//        let request: NSFetchRequest<UserSetting> = UserSetting.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", id)
//        return try? context.fetch(request).first
//    }
//}
