//
//  BestSellersViewController.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

//Attention: GoogleAPI key have limited number of calls and since I am loading a lot of books and I am calling the Google API for each Book I have to be carefule so I don't reach the search limit as it will give me a code error can't find coding key under name Item, I am working on, look for updates button that will check for updates upon request at the settings page  as well I can add detailed book cashing and saving to NS Archive but I haven't finish it yet

import UIKit
class BestSellersViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var categoriesPicker: UIPickerView!
    @IBOutlet weak var bestSellerBooksCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var books = [BookWraper](){
        didSet{
            spinTheSpinner()
            //loading the detailed books
            loadDetailedBooksFromBooks(from: books)
            bestSellerBooksCollectionView.reloadData()
            //            bestSellerBooksCollectionView.reloadData()
        }
    }
    var detailedBooks = [DetailedBook](){
        didSet{
            stopTheSpinner()
            print("detailed books loaded", detailedBooks.count)
            print(detailedBooks.last?.volumeInfo.title ?? "nothing to load", detailedBooks.count)
            bestSellerBooksCollectionView.reloadData()
        }
    }
    //Mark: defaults properties
    var defaultSetting: DefaultCategory?
    //Mark: Category Picker Property and Methods
    var categories = [Category](){
        didSet{
            print("categories are set")
            categoriesPicker.setNeedsLayout()
            if let safeDefaults = defaultSetting{
                loadBestSellers(of: defaultSetting!.categoryName)
                print(safeDefaults.categoryIndex)
                categoriesPicker.selectRow(safeDefaults.categoryIndex, inComponent: 0, animated: true)
                //            print("Categories have been set", categories.map{$0.listName})
            }
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].listName
    }
    //PickerView didSelectRow Method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentCategory = categories[row]
        print(currentCategory.listNameEncoded)
        loadBestSellers(of: currentCategory.listNameEncoded)
    }
    //Loading the categories using the NYTimes API
    func loadCategories(){
        CategoryAPIClient.manager.getCategories(for: "", completionHandler: {self.categories = $0}, errorHandler: {print($0)})
    }
    //Loading the best Sellers using the NYTimes API
    func loadBestSellers(of categroy: String) {
        //        ; print(($0.map{$0.bookDetails[0].title}).joined(separator: "\n"))}
        BookAPIClient.manager.getBooks(for: categroy, completionHandler: {self.books = $0}, errorHandler: {print($0)})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Registering the NIB
        let nib = UINib(nibName: "BookCollectionViewCell", bundle: nil)
        //Mark: UICollectionView Delegate and dataSource, remeber delegat is for method function like did select cell and so on, but data source is all about how to populate it and how does it look like
        self.bestSellerBooksCollectionView.delegate = self
        self.bestSellerBooksCollectionView.dataSource = self
        self.bestSellerBooksCollectionView.register(nib, forCellWithReuseIdentifier: "bookCollectionViewCell")
        //Mark: Picker delegation and data source
        self.categoriesPicker.delegate = self
        self.categoriesPicker.dataSource = self
        // setting the favouritsController to be the starting point
        self.tabBarController?.selectedIndex = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        //Check if there is a stored categorie at the defaults, example if the user saved science or whatever from the seting page, and it is in the view willAppear as the didSet doesn't work if it is in the viewDidLoad
        guard categories.isEmpty else {
            return
        }
        let categoryFromDefaults = DefaultCategory.returnValue(inputDefaults: defaults, and: DefaultSettingKeys.userOne.rawValue)
        if let safeCategoryFromDefaults = categoryFromDefaults{
            self.defaultSetting = safeCategoryFromDefaults
            self.categories = safeCategoryFromDefaults.categoryList
        }else{
            loadCategories()
        }
    }
    
    
}
// Extension Content: - Loading Detailed Books - UICollectionViewDataSource Methods - Seguein Function
extension BestSellersViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    //Loading detailed books by looping in the NYtimes book and getting detailed book by either using the isbns and book Titles
    func loadDetailedBooksFromBooks(from books: [BookWraper]){
        // The mystery is resolved; while it looped throught the whole books the function excapes to load the data somhow and if you try to access it before it comes back you will have and empty allDetailed book, and the catch is to wait till the data comes back and make sure it came back with the same number of books that you had from the NYTImes API and then you set the self.detailedBooks
        // to understand it the whole function is done on the main queue but some of its components aren't, thats why if you assign the detailed array at the end of the function instead at the allDetailedBooks's didSet it will have zero elements as they didn't come back yet
        var allDetailedBooks = [DetailedBook](){
            didSet{
                if allDetailedBooks.count == books.count{
                    self.detailedBooks = allDetailedBooks
                }
            }
        }
        for book in books {
            let currentBook = book
            print(currentBook.bookDetails[0].title, currentBook.bookDetails[0].author )
            //            print(currentBook.isbns.first?.isbn10 ?? "no ISBN\(currentBook.isbns.count)")
            //Option1: Loading the books using title at the DetailedBookAPIClient as some books doesnt' have data using isbns at the googlAPI
            DetailedBookAPIClient.manager.getDetaildBookUsingTitle(book: currentBook.bookDetails[0], completionHandler: {allDetailedBooks.append($0[0])}, errorHandler: {print($0)})
            //Option2: Loading the books using the isbn as a backup
            DetailedBookAPIClient.manager.getDetaildBookUsingIsbn(book: currentBook.bookDetails[0], completionHandler: {allDetailedBooks.append($0[0])}, errorHandler: {print($0)})
            
        }
    }
    //Mark: CollectionView properties and methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Mark: NIB
        /*
         guard let cell =  self.bestSellerBooksCollectionView.dequeueReusableCell(withReuseIdentifier: "bookCollectionViewCell", for: indexPath) as? BookColllectionViewCell else{
         return UICollectionViewCell()
         }
         cell.bookShortDescription.text =  bookSetup.bookDetails.first?.description
         cell.bookTitle.text = bookSetup.bookDetails.first?.author
         cell.bookPoster.image = #imageLiteral(resourceName: "NoteBook")
         guard !detailedBooks.isEmpty else {
         return cell
         }
         let detailedBookSetup = detailedBooks[indexPath.row]
         ImageAPIClient.manager.getImage(from: (detailedBookSetup.volumeInfo.imageLinks?.smallThumbnail)!, completionHandler: {cell.bookPoster.image = $0; cell.setNeedsLayout()}, errorHandler: {print($0)})
         return cell
         */
        guard let cell =  bestSellerBooksCollectionView.dequeueReusableCell(withReuseIdentifier: "bestSellerCell", for: indexPath) as? BestSellerBookCollectionViewCell else {
            return UICollectionViewCell()
        }
        let bookSetup = books[indexPath.row]
        cell.bookShortDescription.text = bookSetup.bestsellersDate + "\n" + (bookSetup.bookDetails.first?.description)!
        cell.bookTitle.text = bookSetup.bookDetails.first?.author
        cell.bookPoster.image = #imageLiteral(resourceName: "NoteBook")
        guard !detailedBooks.isEmpty else {
            return cell
        }
        let detailedBook = detailedBooks.filter{($0.volumeInfo.title?.lowercased().contains(bookSetup.bookDetails.first!.title.lowercased()))!}
        if let detailedBookSetup = detailedBook.first{
            ImageAPIClient.manager.getImage(from: (detailedBookSetup.volumeInfo.imageLinks?.smallThumbnail)!, completionHandler: {cell.bookPoster.image = $0; cell.setNeedsLayout()}, errorHandler: {print($0)})
        }
        
        //        cell.bookTitle.text = detailedBookSetup.volumeInfo.authors?.joined(separator: " ")
        return cell
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //I have used the custom UICollectionViewCell as seguing from a nib doesn't work and I had to use the cellIsSelected method but I choosed to do it using segue
        //        print("item pressed")
        switch segue.identifier {
        case "detailedBookSegue"?:
            if let desination =  segue.destination as? DetailedBookViewController{
                print("I am segueing")
                let bookSetup = books[(bestSellerBooksCollectionView.indexPathsForSelectedItems?.first?.row)!]
                let detailedBook = detailedBooks.filter{($0.volumeInfo.title?.lowercased().contains(bookSetup.bookDetails.first!.title.lowercased()))!}
                // this is because the books in the detailed book and in the book doesn't have the same index
                if let detailedBookSetup = detailedBook.first{
                    desination.detailedBook = detailedBookSetup
                }else{
                    desination.book = bookSetup.bookDetails.first
                }
            }
        default:
            return
        }
    }
}
//Spenner Functions
extension BestSellersViewController{
    func spinTheSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    func stopTheSpinner() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    
    
}
