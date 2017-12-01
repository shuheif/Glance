//
//  PostViewController.swift
//  Stories
//
//  Created by Shuhei Fujita on 10/1/17.
//  Copyright © 2017 Shuhei Fujita. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    var model: PostViewModel!
    var placeHolderLabel: UILabel!
    var bottomConstraint: NSLayoutConstraint?
    var image: UIImage?
    var imageURL: String?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBAction func postButtonPushed(_ sender: UIButton) {
        if !textView.text.isEmpty {
            model.post(caption: textView.text!, imageURL: imageURL)
            performSegue(withIdentifier: "unwindFromPostToHome", sender: self)
        }
    }
    
    @IBAction func cameraButtonPushed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.delegate = self
            self.present(camera, animated: true, completion: nil)
        } else {
            //Show alert here
            print("camera is not available")
        }
    }
    
    @IBAction func albumButtonPushed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let cameraRoll = UIImagePickerController()
            cameraRoll.sourceType = .photoLibrary
            cameraRoll.delegate = self
            self.present(cameraRoll, animated: true, completion: nil)
        } else {
            //Show alert here
            print("photoLibrary is not available")
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindFromPostToHome", sender: self)
    }
    
    override func loadView() {
        if let view = UINib(nibName: "PostViewController", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = PostViewModel()
        textView.placeholder = "What's happneing?"
        
        
        // ToolView
        bottomConstraint = NSLayoutConstraint(item: toolView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
        
        toolView.bringSubview(toFront: toolView)
    }

    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardScreenEndFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}


extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("imagePickerContoller")
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //let pickedURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        var documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        documentDirectory.append(UUID().uuidString)
        
        let data = UIImagePNGRepresentation(pickedImage)
        do {
            try data?.write(to: URL(fileURLWithPath: documentDirectory))
        } catch {
            print("file rewrite error")
            return
        }
        image = pickedImage
        imageURL = documentDirectory
        showImage()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showImage() {
        print("showImage")
        if image != nil {
            imageView.image = image
            imageViewWidthConstraint.constant = 100
        }
    }
}
