//
//  ViewController.swift
//  Meme
//
//  Created by Andi Xu on 5/27/21.
//

import UIKit

struct Meme{
    var topText: String
    var bottomText: String
    var oriImage: UIImage
    var editedImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate, UITextFieldDelegate {

   
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var textfieldTOP: UITextField!
    @IBOutlet weak var textfieldBOTTOM: UITextField!
  
    
    @IBAction func cancelEditPage(_ sender: Any) {
        jumpToSentMemes()
    }
    func jumpToSentMemes(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled=false
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        // textField setting
        textfieldBOTTOM.delegate = self
        textfieldTOP.delegate = self
        
        textfieldBOTTOM.isHidden = true
        textfieldTOP.isHidden = true

        textfieldBOTTOM.text="BOTTOM"
        textfieldTOP.text="TOP"
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor(ciColor: .black),
            NSAttributedString.Key.foregroundColor: UIColor(ciColor: .black),
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  5
        ]
        
        textfieldBOTTOM.defaultTextAttributes = memeTextAttributes
        textfieldTOP.defaultTextAttributes = memeTextAttributes
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imagePickerView.contentMode=UIView.ContentMode.scaleAspectFit
            imagePickerView.image = image
            shareButton.isEnabled=true
        }
        textfieldBOTTOM.isHidden = false
        textfieldTOP.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == textfieldTOP && textField.text == "TOP"{
                textField.text = " "
            }
            if textField == textfieldBOTTOM && textField.text == "BOTTOM"{
                textField.text = " "
            }
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    // adjust keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textfieldBOTTOM.isFirstResponder {
           view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // create your new meme
    func save() {
        let newMeme = Meme(topText: textfieldTOP.text!, bottomText: textfieldBOTTOM.text!, oriImage: imagePickerView.image!, editedImage: generateMemedImage())
        
      
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(newMeme)
        
    }
    
    func generateMemedImage() -> UIImage {

        // Hide toolbar and navbar
        navigationController?.isNavigationBarHidden = true
        navigationController?.setToolbarHidden(true, animated: false)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        navigationController?.isNavigationBarHidden = false
        navigationController?.setToolbarHidden(false, animated: false)

        return memedImage
    }
    
    @IBAction func share(_ sender: Any){
        //generate a memed image
        let memedImage=generateMemedImage()
        //define an instance of the ActivityViewController
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {(activityType, completed, returnedItems, error)  in
            if completed {
                self.save()
                controller.dismiss(animated: true, completion: nil)
                self.jumpToSentMemes()
            }
        }
        //present(controller, animated: true)
        
    }
    
    
   
    
    
    
    
    
}

