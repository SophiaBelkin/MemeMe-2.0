//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sophia Lu on 7/16/21.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var memeImage: UIImage?
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isToolbarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = memeImage
      
    }
}
