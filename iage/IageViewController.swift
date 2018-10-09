//
//  IageViewController.swift
//  iage
//
//  Created by Александр Комаров on 21.02.2018.
//  Copyright © 2018 Александр Комаров. All rights reserved.
//

import Cocoa

class IageViewController: NSViewController, NSTextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate = NSApplication.shared.delegate as! AppDelegate
        dateField.stringValue = String(delegate.birthDay)
        monthSelect.selectItem(at: delegate.birthMonth - 1)
        yearField.stringValue = String(delegate.birthYear)
        fractionalPartLengthField.stringValue = String(delegate.fractionalPartLength)
        dateField.delegate = self
        yearField.delegate = self
        fractionalPartLengthField.delegate = self
    }
    
    @IBOutlet weak var dateField: NSTextField!
    @IBOutlet weak var monthSelect: NSPopUpButton!
    @IBOutlet weak var yearField: NSTextField!
    @IBOutlet weak var fractionalPartLengthField: NSTextField!

    @IBAction func quitAction(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    @IBAction func monthSelected(_ sender: NSPopUpButton) {
        let delegate = NSApplication.shared.delegate as! AppDelegate
        delegate.birthMonth = sender.indexOfSelectedItem + 1
        delegate.refresh()
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let delegate = NSApplication.shared.delegate as! AppDelegate
            if (textField.tag == 1) {
                // date
                if let number = Int(textField.stringValue) {
                    delegate.birthDay = number
                }
            }
            if (textField.tag == 2) {
                // year
                if let number = Int(textField.stringValue) {
                    delegate.birthYear = number
                }
            }
            if (textField.tag == 3) {
                // frac part length
                if let number = Int(textField.stringValue) {
                    delegate.fractionalPartLength = number
                }
            }
            delegate.refresh()
        }
    }
}

extension IageViewController {
    static func freshController() -> IageViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "IageViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? IageViewController else {
            fatalError("Cannot find IageViewController")
        }
        return viewcontroller
    }
}
