//
//  Model.swift
//  Week1.1
//
//  Created by iosdev on 9/9/17.
//  Copyright © 2017 iosdev. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object{
    dynamic var username = ""
    let todos = List<Todoes>()
}

class Todoes: Object{
    dynamic var todo = ""
    dynamic var dateandtime = ""
    
//    init() {
//        
//    }
//    
//    init(todo: String, dateandtime: String) {
//        self.todo = todo
//        self.dateandtime = dateandtime
//    }
}
