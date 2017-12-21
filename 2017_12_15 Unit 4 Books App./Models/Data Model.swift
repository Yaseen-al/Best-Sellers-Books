//
//  Data Model.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import Foundation
class FavouriteBookDataModel {
    //step one is to make your file name
    static let kPathName = "favouriteBooks.plist"
    //intiate your class as a single tone
    private init(){}
    static let shared = FavouriteBookDataModel()
    //create your data storage and saving when you update it
    private var detailedBooksList = [DetailedBook]() {
        didSet {
            saveDetailedFavoriteList()
            print(documentDirectory()) //to print the directory of your file
        }
    }
    //Assign your methods of creating your directory, make the file path, load your data from the file, save your data, get your data storage after it has been loaded
    //returns Documents directory path for the App
    func documentDirectory()->URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0] //the 0 is the document folder
    }
    
    //returns supplied path name in documents directory
    private func dataFilePath(pathName: String)->URL {
        return FavouriteBookDataModel.shared.documentDirectory().appendingPathComponent(pathName)
    }
    
    //Load you need to load your data in the view didlOad in order to acces the stuff saved on the app if you didn't do that you will have it empty
    //what is happening in loading is just decoding what the list have
    func loadDetailedBooksFavoriteList(){
        //make your decoder
        let decoder = PropertyListDecoder()
        // make the path
        let path = dataFilePath(pathName: FavouriteBookDataModel.kPathName)
        do {
            //try to get the raw data using the path
            let data = try Data.init(contentsOf: path)
            // convert the raw data to a specific type
            detailedBooksList = try decoder.decode([DetailedBook].self, from: data)
        } catch {print("decoder error: \(error.localizedDescription)")}
    }
    
    //Save (encode)
    func saveDetailedFavoriteList(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(detailedBooksList)
            try data.write(to: dataFilePath(pathName: FavouriteBookDataModel.kPathName), options: .atomic)
        }
        catch {print("encoder error: \(error.localizedDescription)")}
    }
    
    //Read (get) after it has been loaded at the begining of the programe
    func getDetailedBooksFavoriteList() -> [DetailedBook]{
        return detailedBooksList
    }

    //Add
    func addDetailedBookFavoriteLis(book item: DetailedBook) {
        var isItThere = false
        for book in detailedBooksList{
            if book.id == item.id{
                isItThere = true
            }
        }
        if !isItThere{
        detailedBooksList.append(item)
        }
    }
    //Update
    func updateDetailedBookFavoriteList(withUpdatedItem item: DetailedBook){
        if let index = detailedBooksList.index(where: {$0.volumeInfo.title == item.volumeInfo.title}) {
            detailedBooksList[index] = item
        }
    }
    //Delete selected book from Favorite List
    func deleteDetailedBoookFavoriteList(fromIndex index: Int){
        detailedBooksList.remove(at: index)
    }
    
}

/*
 
class CategorieskDataModel {
    //step one is to make your file name
    static let kPathName = "CategoryList.plist"
    //intiate your class as a single tone
    private init(){}
    static let shared = CategorieskDataModel()
    //create your data storage and saving when you update it
    private var categoriesList = [Category]() {
        didSet {
            saveCategoryList()
            print(documentDirectory()) //to print the directory of your file
        }
    }
    //Assign your methods of creating your directory, make the file path, load your data from the file, save your data, get your data storage after it has been loaded
    //returns Documents directory path for the App
    func documentDirectory()->URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0] //the 0 is the document folder
    }
    //returns supplied path name in documents directory
    private func dataFilePath(pathName: String)->URL {
        return CategorieskDataModel.shared.documentDirectory().appendingPathComponent(pathName)
    }
    
    //Load you need to load your data in the view didlOad in order to acces the stuff saved on the app if you didn't do that you will have it empty
    //what is happening in loading is just decoding what the list have
    func loadCategoryList(){
        //make your decoder
        let decoder = PropertyListDecoder()
        // make the path
        let path = dataFilePath(pathName: FavouriteBookDataModel.kPathName)
        do {
            //try to get the raw data using the path
            let data = try Data.init(contentsOf: path)
            // convert the raw data to a specific type
            categoriesList = try decoder.decode([Category].self, from: data)
        } catch {print("decoder error: \(error.localizedDescription)")}
    }
    
    //Save (encode)
    func saveCategoryList(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(categoriesList)
            try data.write(to: dataFilePath(pathName: CategorieskDataModel.kPathName), options: .atomic)
        }
        catch {print("encoder error: \(error.localizedDescription)")}
    }
    
    //Read (get) after it has been loaded at the begining of the programe
    func getCategoryList() -> [Category]{
        return categoriesList
    }
    
    //Add
    func addDetailedBookFavoriteLis(book item: Category) {
        var isItThere = false
        for category in categoriesList{
            if category.listName == item.listName{
                isItThere = true
            }
        }
        if !isItThere{
            categoriesList.append(item)
        }
    }
    //Update
    func updateCategoryList(withUpdatedItem item: Category){
        if let index = categoriesList.index(where: {$0.listName == item.listName}) {
            categoriesList[index] = item
        }
    }
    //Delete selected book from Favorite List
    func deleteCategoryFromList(fromIndex index: Int){
        categoriesList.remove(at: index)
    }
    
}
*/







