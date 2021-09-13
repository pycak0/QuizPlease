//
//  AlertExtensions.swift
//  QuizPlease
//
//  Created by Владислав on 03.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

extension UIViewController {
    //MARK:- Simple Alert
    /**A simple alert that gives some additional info,
     has only one  button which dismisses the alert controller by default.
     Use it for displaying supplementary messages e.g. successful url request.
     Default button title is 'OK', also any action can be assigned to the button with the closure.
     */
    func showSimpleAlert(title: String = "Успешно!", message: String = "", okButtonTitle: String = "OK", okButtonStyle: UIAlertAction.Style = .default, okHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       // alert.view.tintColor = tintColor
        let okBtn = UIAlertAction(title: okButtonTitle, style: okButtonStyle, handler: okHandler)
        alert.addAction(okBtn)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Show Alert With 2 Buttons
    ///All messages are customizable and both buttons may be handled (or not)
    func showTwoOptionsAlert(title: String, message: String, option1Title: String, handler1: ((UIAlertAction) -> Void)?, option2Title: String, handler2: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //alert.view.tintColor = tintColor
        let option1 = UIAlertAction(title: option1Title, style: .default, handler: handler1)
        let option2 = UIAlertAction(title: option2Title, style: .default, handler: handler2)
        
        alert.addAction(option1)
        alert.addAction(option2)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Show Action Sheet With Configurable Option
    ///Cancel button is set by default
    func showActionSheetWithOptions(title: String?, buttons: [UIAlertAction], buttonTextAligment: CATextLayerAlignmentMode = .center, cancelTitle: String = "Отмена", tintColor: UIColor? = .labelAdapted) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = tintColor
        
        buttons.forEach { (button) in
            //button.titleAlignment = buttonTextAligment
            alert.addAction(button)
        }
        
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Text Field Alert
    func showAlertWithTextField(
        title: String,
        message: String,
        textFieldText: String? = nil,
        placeholder: String? = nil,
        contentType: UITextContentType = .nickname,
        textAlignment: NSTextAlignment = .left,
        cancelTitle: String = "Отмена",
        cancelHandler: ((UIAlertAction) -> Void)? = nil,
        okTitle: String = "OK",
        okHandler: ((_ textFieldText: String) -> Void)?
    ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //alert.view.tintColor = tintColor
        let cancelBtn = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        let okBtn = UIAlertAction(title: okTitle, style: .default) { (okAction) in
            let text = alert.textFields?.first?.text ?? ""
            okHandler?(text)
        }

        alert.addAction(cancelBtn)
        alert.addAction(okBtn)
        
        alert.addTextField { (field) in
            field.text = textFieldText
            field.placeholder = placeholder
            field.clearButtonMode = .always
            field.textContentType = contentType
            field.textAlignment = textAlignment
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Error Connecting To Server Alert
    ///Not as good as 'simple alert' but is very easy to call specially for internet issues
    func showErrorConnectingToServerAlert(title: String = "Не удалось связаться с сервером", message: String = "Повторите попытку позже"){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //alert.view.tintColor = tintColor
        let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    func showNeedsAuthAlert(title: String = "Ошибка авторизации", message: String = "Вы можете авторизоваться или зарегистрироваться в Личном кабинете") {
        showSimpleAlert(title: title, message: message, okButtonTitle: "OK", okHandler: nil)
    }
    
    func showChooseItemActionSheet(itemNames: [String], tintColor: UIColor? = .labelAdapted, completion: ((_ selectedName: String, _ index: Int) -> Void)?) {
        var buttons = [UIAlertAction]()
        for name in itemNames {
            buttons.append(
                UIAlertAction(title: name, style: .default) { (action) in
                    let index = Int(itemNames.firstIndex(of: name)!)
                    completion?(name, index)
                }
            )
        }
        showActionSheetWithOptions(title: nil, buttons: buttons, tintColor: tintColor)
    }
    
//    func showPickerSheet(_ title: String, with values: [String], selectedIndex: Int,
//                         cancelButtonTitle: String = "Готово",
//                         handler: @escaping (_ selectedIndex: Int) -> Void) {
//        let alert = UIAlertController(style: .actionSheet, title: title, message: nil)
//        //works incorrect
//        //alert.view.tintColor = .labelAdapted
//        alert.addPickerView(values: [values], initialSelection: (column: 0, row: selectedIndex)) { (_, picker, _, _) in
//            handler(picker.selectedRow(inComponent: 0))
//        }
//        alert.addAction(title: cancelButtonTitle, style: .cancel)
//        present(alert, animated: true)
//    }
    
    func showSimpleAlert(
        attributedTitle: NSAttributedString,
        attributedMessage: NSAttributedString = NSAttributedString(string: ""),
        okButtonTitle: String = "OK",
        okButtonStyle: UIAlertAction.Style = .default,
        okHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        let okBtn = UIAlertAction(title: okButtonTitle, style: okButtonStyle, handler: okHandler)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
}
