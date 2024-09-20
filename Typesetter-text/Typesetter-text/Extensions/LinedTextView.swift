//
//  LinedTextView.swift
//  Typesetter-text
//
//  Created by Karen Khachatryan on 20.09.24.
//

import UIKit

class LinedTextView: UITextView, UITextViewDelegate {
    
    private var linedBackgroundView: LinedBackgroundView!
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        linedBackgroundView = LinedBackgroundView(frame: self.bounds)
        linedBackgroundView.backgroundColor = .clear
        linedBackgroundView.isUserInteractionEnabled = false
        
        self.insertSubview(linedBackgroundView, at: 0)
        
        self.delegate = self
        self.font = .medium(size: 16)
        
        linedBackgroundView.lineHeight = self.font!.lineHeight
        linedBackgroundView.topInset = self.textContainerInset.top
        
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.isScrollEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        linedBackgroundView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: max(self.contentSize.height, self.bounds.height))
        
        linedBackgroundView.setNeedsDisplay()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        linedBackgroundView.frame.origin.y = self.contentOffset.y
    }
}




class LinedBackgroundView: UIView {
    
    var lineHeight: CGFloat = UIFont.medium(size: 16)!.lineHeight
    var topInset: CGFloat = 10
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1.0)
        let numberOfLines = Int(self.bounds.height / lineHeight)
        for i in 0...numberOfLines {
            let lineY = topInset + CGFloat(i) * lineHeight
            context.move(to: CGPoint(x: 0, y: lineY))
            context.addLine(to: CGPoint(x: self.bounds.width, y: lineY))
        }
        context.strokePath()
    }
}
