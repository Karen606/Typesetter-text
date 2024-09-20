//
//  DialogView.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 20.09.24.
//

import UIKit

protocol DialogViewDelegate: AnyObject {
    func save()
    func close()
}

class DialogView: UIView {

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: DialogViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib() -> DialogView {
        return UINib(nibName: "DialogView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogView
    }
    
    func commonInit() {
        titleLabel.font = .semibold(size: 24)
        yesButton.titleLabel?.font = .semibold(size: 24)
        noButton.titleLabel?.font = .semibold(size: 24)
    }
    
    @IBAction func clickedClose(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func clickedYes(_ sender: UIButton) {
        delegate?.save()
    }
    
    @IBAction func clickedNo(_ sender: UIButton) {
        self.removeFromSuperview()
        delegate?.close()
    }
}
