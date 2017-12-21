//
//  FavouriteBooksViewController.swift
//  2017_12_15 Unit 4 Books App.
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 Quark. All rights reserved.
//

import UIKit

class FavouriteBooksViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var favouriteBooksCollectionView: UICollectionView!
    var favouriteBooks = [DetailedBook](){
        didSet{
            favouriteBooksCollectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO:
        guard indexPath.row < favouriteBooks.count else {
            return UICollectionViewCell()
        }
        let detailedBookSetup = favouriteBooks[indexPath.row]
        guard let cell = favouriteBooksCollectionView.dequeueReusableCell(withReuseIdentifier: "favouriteCell", for: indexPath) as? FavouriteBookCollectionViewCell else {
            return UICollectionViewCell()
        }
        ImageAPIClient.manager.getImage(from: (detailedBookSetup.volumeInfo.imageLinks?.smallThumbnail)!, completionHandler: {cell.bookPoster.image = $0}, errorHandler: {print($0)})
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavouriteBookDataModel.shared.loadDetailedBooksFavoriteList()
        self.favouriteBooks = FavouriteBookDataModel.shared.getDetailedBooksFavoriteList()
        self.favouriteBooksCollectionView.delegate = self
        self.favouriteBooksCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        FavouriteBookDataModel.shared.loadDetailedBooksFavoriteList()
        self.favouriteBooks = FavouriteBookDataModel.shared.getDetailedBooksFavoriteList()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailedBookViewController{
            let detailedBookSetup = favouriteBooks[(favouriteBooksCollectionView.indexPathsForSelectedItems?.first?.row)!]
            destination.detailedBook = detailedBookSetup
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
