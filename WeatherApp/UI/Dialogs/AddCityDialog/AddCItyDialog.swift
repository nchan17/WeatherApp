//
//  AddCItyDialog.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/8/21.
//

import Foundation

import UIKit

protocol AddCityDelegate: class {
    func didPressAddCityButton(_ sender: AddCityDialog)
}

class AddCityDialog: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var textField: UITextField!
    
    weak var delegate: AddCityDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setup()
    }
    
    private func commonInit(){
        let bundle = Bundle(for: AddCityDialog.self)
        bundle.loadNibNamed("AddCityDialog", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    private func setup(){
        contentView.layer.cornerRadius = 20
    }
    
    @IBAction func addCityPressed() {
        delegate?.didPressAddCityButton(self)
    }
    
    
}
