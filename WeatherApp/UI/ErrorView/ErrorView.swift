//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/6/21.
//

import UIKit

protocol ErrorViewDelegate: class {
    func didPressRefreshButton(_ sender: ErrorView)
}

class ErrorView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var reloadButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    weak var delegate: ErrorViewDelegate?
    
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
        let bundle = Bundle(for: ErrorView.self)
        bundle.loadNibNamed("ErrorView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    private func setup(){
        reloadButton?.layer.cornerRadius = 5
    }
    
    @IBAction func addCityPressed() {
        delegate?.didPressRefreshButton(self)
    }
    
}


