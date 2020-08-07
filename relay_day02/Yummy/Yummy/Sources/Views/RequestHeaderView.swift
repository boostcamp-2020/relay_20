//
//  RequestHeaderView.swift
//  Yummy
//
//  Created by woong on 2020/08/07.
//  Copyright © 2020 woong. All rights reserved.
//

import UIKit

class RequestHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    /**
     버튼이 클릭되면 urlTextField를 내보낼 클로저
     */
    var urlTextWhenTouchRequestButton: ((String?) -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
     textField, button이 들어있는 backgroundView
     */
    @IBOutlet weak var myBackgroundView: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBAction func touchRequestButton(_ sender: UIButton) {
        urlTextWhenTouchRequestButton?(urlTextField.text)
    }
}
