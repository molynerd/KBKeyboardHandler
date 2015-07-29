//
//  ViewController.swift
//  KBKeyboardHandler
//
//  Created by Nicholas Molyneux on 7/28/15.
//  Copyright © 2015 Nicholas Molyneux. All rights reserved.
//

import UIKit

class ViewController: UIViewController, KBKeyboardHandlerDelegate, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    var keyboardHandler: KBKeyboardHandler?
    
    func keyboardSizeChanged(delta: CGSize) {
        self.view.frame.size.height -= delta.height
    }
    
    override func viewDidAppear(animated: Bool) {
        self.keyboardHandler = KBKeyboardHandler()
        self.keyboardHandler!.delegate = self
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.keyboardHandler = nil
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

