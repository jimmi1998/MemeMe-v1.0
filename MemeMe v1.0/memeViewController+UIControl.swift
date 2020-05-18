//
//  memeViewController+UIControl.swift
//  MemeMe v1.0
//
//  Created by Jimit Raval on 20/04/20.
//  Copyright © 2020 Mango. All rights reserved.
//

import Foundation
import UIKit

extension MemeViewController {
    // MARK : UI func
    func initializeTextFields(){
        setupTextFieldStyle(toTextField: topText, defaultText: "")
        setupTextFieldStyle(toTextField: bottomText, defaultText: "")
    }
    
    func reinitializeUI(){
        updateTextFieldText(textField: topText, text: "")
        updateTextFieldText(textField: bottomText, text: "")
        enableOrDisableTopBarButton(enable: false)
        imageView.image = .none
    }
    
    func setupTextFieldStyle(toTextField textField: UITextField, defaultText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        textField.text = defaultText
    }
    
    
    func updateTextFieldText(textField: UITextField, text: String){
        textField.text = text
    }
    
    func disableButton() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        enableOrDisableTopBarButton(enable: false)
    }
    
    func enableOrDisableTopBarButton(enable: Bool){
        shareButton.isEnabled = enable
        cancelButton.isEnabled = enable
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Informations", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in print("OK tapped")}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideOrShowToolbars(hide: Bool) {
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    func updateFont(font: String) {
        topText.font = UIFont(name: font, size: 40)
        bottomText.font = UIFont(name: font, size: 40)
    }
}

