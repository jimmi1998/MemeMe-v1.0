//
//  MemeViewController.swift
//  MemeMe v1.0
//
//  Created by Jimit Raval on 20/04/20.
//  Copyright © 2020 Mango. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomText: UITextField!
    
    var selectTextField: UITextField?
    
    var meme: memeStruct?
    let memeTextAttributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black, .strokeWidth: -3.0, .foregroundColor: UIColor.white, .font: UIFont(name: "Impact", size: 50)!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableButton()
        initializeTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK:- MEME func
    func saveMeme(meme: UIImage){
        let meme = memeStruct(topText: topText.text!, bottomText: bottomText.text!, imageview: imageView.image!, meme: meme)
        self.meme = meme
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        presentAlert(message: "Your MEME is saved in the Library")
        
    }
    
    func generateMemedImage() -> UIImage {
        hideOrShowToolbars(hide: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideOrShowToolbars(hide: false)

        return memedImage
    }
    
    //MARK: - Actions
    @IBAction func share(_ sender: Any) {
        let memeToShare = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activity.completionWithItemsHandler = { (activity, success, items, error) in if success { self.saveMeme(meme:memeToShare) } }
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func fontChange(_ sender: Any) {
        let alert = UIAlertController(title: "Font Change", message: "Choose any font type", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Helvetica", style: .default, handler: { _ in self.updateFont(font: "HelveticaNeue-CondensedBlack")}))
        alert.addAction(UIAlertAction(title: "Futura", style: .default, handler: { _ in self.updateFont(font: "Futura-Medium")}))
        alert.addAction(UIAlertAction(title: "Marker Felt", style: .default, handler: { _ in self.updateFont(font: "MarkerFelt-Wide")}))
        alert.addAction(UIAlertAction(title: "Impact", style: .default, handler: { _ in self.updateFont(font: "Impact")}))
            
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in print("Cancel")}))
            
        
        present(alert, animated: true, completion: nil)
    }
    

    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            openImagePicker(.photoLibrary)
        } else if sender.tag == 1 {
            openImagePicker(.camera)
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        reinitializeUI()
        presentAlert(message: "All changes will be discarded")
    }
    
    func openImagePicker(_ type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    
    // Delegate performed when the user cancel picking an image
    // From : UIImagePickerControllerDelegate protocol
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User Cancel picking an image")
        dismiss(animated: true, completion: nil)
    }
    
    // Delegate perfomed when pickImageFromLibrary() Action is tapped
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage ] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            enableOrDisableTopBarButton(enable: true)
            updateTextFieldText(textField: topText, text: "TOP")
            updateTextFieldText(textField: bottomText, text: "BOTTOM")
        }else {
            enableOrDisableTopBarButton(enable: false)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Delegate performed when a textField is tap
    // From : UITextFieldDelegate protocol
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectTextField = textField
        updateTextFieldText(textField: textField, text: "")
    }
    
    // Delegate performed when return keyboard button is tapped
    // From : UITextFieldDelegate protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

