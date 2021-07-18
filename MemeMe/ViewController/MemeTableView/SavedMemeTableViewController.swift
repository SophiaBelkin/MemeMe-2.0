//
//  SavedMemeTableViewController.swift
//  MemeMe
//
//  Created by Sophia Lu on 7/16/21.
//

import UIKit


class SavedMemeTableViewController: UITableViewController {
    
    var editMemeVC: MemeEditorViewController? = MemeEditorViewController()
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        editMemeVC?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    @IBAction func addMeme(_ sender: UIBarButtonItem) {
        let navController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorNav") as! UINavigationController
        
        show(navController, sender: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! SavedMemeTableViewCell

        let meme = memes[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
        cell.memeTitle?.text = meme.topText + " " + meme.bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.00
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailVC.memeImage = memes[indexPath.row].memedImage
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

}


extension SavedMemeTableViewController: SavedMemeDelegateProtocol {
    func didAddMeme() {
        tableView.reloadData()
    }
}
