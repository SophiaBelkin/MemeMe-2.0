//
//  ViewController.swift
//  MemeMe
//
//  Created by Sophia Lu on 7/15/21.
//

import UIKit

protocol SavedMemeDelegateProtocol {
    func didAddMeme()
}

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.0
    ]
    
    var delegate: SavedMemeDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        // Hide Keyboard by touching Anywhere outside UITextField iOS
        dismissKey()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set TextField default state
        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")
        subscribeToNotifications()
        displayNavBars(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToNotifications()
    }

    private func setupTextField(_ textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unSubscribeToNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .camera)
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    
    @IBAction func reset(_ sender: UIBarButtonItem) {
        guideLabel.isHidden = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)

        activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
        Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.save(memedImage)
            } else {
                print("cancel")
            }
        }
    }
    
    private func displayNavBars(_ show: Bool) {
        navigationController?.isToolbarHidden = show
        navigationController?.isNavigationBarHidden = show
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
    }
    
    func save(_ memedImage : UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.memes.append(meme)
        
        delegate?.didAddMeme()
        dismiss(animated: true, completion: nil)
    }
   
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        displayNavBars(false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        displayNavBars(true)
        
        return memedImage
    }
}
