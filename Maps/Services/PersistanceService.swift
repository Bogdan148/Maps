//
//  PersistanceService.swift
//  Maps
//
//  Created by Bodya on 19.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import Foundation
import RealmSwift

class PersistanceService  {
    
    private init() {}
    static let shared = PersistanceService()
    
    var realm = try! Realm()
    
    func create<T: Object>(object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    func update<T: Object>(object: T) {
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    func delete<T: Object>(object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error)
        }
    }
}
