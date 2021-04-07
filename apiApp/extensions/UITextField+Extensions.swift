//
//  UITextField+Extensions.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 24.03.2021.
//

import UIKit


extension UITextField  {
    func addDoneButton() {
        let screenWith = UIScreen.main.bounds.width
        let doneToolBar : UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWith , height: 50))
        doneToolBar.barStyle = .default
        let flexBArButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let items = [flexBArButtonItem , doneBarButtonItem]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
}
