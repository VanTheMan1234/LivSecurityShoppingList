//
//  CloudKitEnums.swift
//  LivSecurityShoppingList
//
//  Created by Vanoshan  Ramdhani on 2022/03/01.
//
import CloudKit
import UIKit

enum Database{
    static let databaseShoppingList = CKContainer(identifier: "iCloud.iOSShopping").publicCloudDatabase
}
enum RecordTypes {
    static let ShoppingList = "ShoppingItem"
}
enum Records{
    static let shoppingItem = "name"
}

