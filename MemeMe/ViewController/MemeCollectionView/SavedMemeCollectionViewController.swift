//
//  SavedMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Sophia Lu on 7/16/21.
//

import UIKit

class SavedMemeCollectionViewController: UICollectionViewController {

    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    var editMemeVC: MemeEditorViewController? = MemeEditorViewController()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editMemeVC?.delegate = self
        
        // Set collection view flow layout
        let space:CGFloat = 3.0
            let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! SavedMemeCollectionViewCell
    
        let meme = memes[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailVC.memeImage = memes[indexPath.row].memedImage
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    

    @IBAction func addMeme(_ sender: Any) {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorNav") as! UINavigationController
        
        
        present(navController, animated: true, completion: nil)
    }
}

extension SavedMemeCollectionViewController: SavedMemeDelegateProtocol {
    func didAddMeme() {
        collectionView.reloadData()
    }
}
