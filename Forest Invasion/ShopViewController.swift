//
//  ShopViewController.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 17/07/2021.
//

import UIKit

let reusableCell = "itemCell"

class ShopViewController: UIViewController {

    // MARK: - LOADING
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - OUTLETS
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    


}

extension ShopViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2000
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCell, for: indexPath) as! ItemCollectionViewCell
        
        cell.itemImage.image = UIImage(named: "arrow")
        
        return cell
        
    }
    
    
    
}
