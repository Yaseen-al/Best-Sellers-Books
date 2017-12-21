//
//  DetailedBookViewController.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import UIKit

class DetailedBookViewController: UIViewController {
    
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookPoster: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    @IBAction func addToFavouriteButton(_ sender: Any) {
        guard let detailedBook = detailedBook else {
            return
        }
        
        let alert = UIAlertController(title: "Added to the favourites", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        
        // to make it apear on the screen
        present(alert, animated: true, completion: {self.tabBarController?.selectedIndex = 1})
        FavouriteBookDataModel.shared.addDetailedBookFavoriteLis(book: detailedBook)
    }
    var detailedBook: DetailedBook?
    var book: Book?
    func setDetailedBook(){
        //Setting the detailed book
        guard let detailedBook = detailedBook else {
            setBook()
            return
        }
        bookTitle.text = detailedBook.volumeInfo.title
        bookDescription.text = detailedBook.volumeInfo.description
        bookAuthorLabel.text = detailedBook.volumeInfo.authors?.joined(separator: " ") ?? "Unregestired Authors"
        guard let image = detailedBook.volumeInfo.imageLinks?.thumbnail else {
            return
        }
        ImageAPIClient.manager.getImage(from: image, completionHandler: {self.bookPoster.image = $0}, errorHandler: {print($0)})
    }
    func setBook() {
        // Setting a Book
        guard let book = book else {
            return
        }
        bookTitle.text = book.title
        bookDescription.text = book.description
        bookAuthorLabel.text = book.author
        bookPoster.image = #imageLiteral(resourceName: "NoteBook")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetailedBook()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
