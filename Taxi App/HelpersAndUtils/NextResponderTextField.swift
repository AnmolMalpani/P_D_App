//
//  NextResponderTextField.swift
//  NextResponderTextField
//
//  Created by mohamede1945 on 6/20/15.
//  Copyright (c) 2015 Varaw. All rights reserved.
//

import UIKit

/**
Represents a next responder UITextField.
When the instance becomes first responder, and then the user taps the action button (e.g. return keyboard key) 
then one of the following happens:
1. If nextResponderField is not set, keyboard dismissed.
2. If nextResponderField is a UIButton and disabled, then keyboard dismissed.
3. If nextResponderField is a UIButton and enabled, then the UIButton fires touch up inside event (simulating a tap).
4. If nextResponderField is another implementation of UIResponder (e.g. other text field), then it becomes the first responder (e.g. receives keyboard input).

@author mohamede1945
@version 1.0
*/
open class NextResponderTextField: UITextField {
  
    open override func awakeFromNib()
    {
        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.resignFirstResponder()
    }
    

  
    @IBOutlet open weak var nextResponderField: UIResponder?

    /**
    Creates a new view with the passed coder.

    :param: aDecoder The a decoder

    :returns: the created new view.
    */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    /**
    Creates a new view with the passed frame.

    :param: frame The frame

    :returns: the created new view.
    */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    /**
    Sets up the view.
    */
    private func setUp() {
        addTarget(self, action: #selector(actionKeyboardButtonTapped(sender:)), for: .editingDidEndOnExit)
    }

    /**
    Action keyboard button tapped.

    :param: sender The sender of the action parameter.
    */
    @objc private func actionKeyboardButtonTapped(sender: UITextField) {
        switch nextResponderField {
        case let button as UIButton where button.isEnabled:
            button.sendActions(for: .touchUpInside)
        case .some(let responder):
            responder.becomeFirstResponder()
        default:
            resignFirstResponder()
        }
    }
}
