//
//  ErrorDialog.swift
//  WeatherApp
//
//  Created by Nino Chanturia on 2/8/21.
//

import Foundation
import UIKit

class ErrorDialog: UIView {
    @IBOutlet var contentView: UIView!
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
        let bundle = Bundle(for: ErrorDialog.self)
        bundle.loadNibNamed("ErrorDialog", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    private func setup(){
        contentView.layer.cornerRadius = 20
    }
}
