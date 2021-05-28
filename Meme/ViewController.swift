//
//  ViewController.swift
//  Meme
//
//  Created by Andi Xu on 5/27/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate, UITextFieldDelegate {

   
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var textfieldTOP: UITextField!
    @IBOutlet weak var textfieldBOTTOM: UITextField!
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if textField == textfieldTOP {
            textField.text = ""
        }
        if textField == textfieldBOTTOM {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    
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
}

