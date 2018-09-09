//
//  ShutterButton.swift
//  GoofyGiphyCamera
//
//  Created by Brendan Manning on 9/8/18.
//  Copyright © 2018 Brendan Manning. All rights reserved.
//

import UIKit

@IBDesignable
class ShutterButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        
        self.setTitle(nil, for: UIControlState.normal);
        
        self.layer.cornerRadius = self.frame.height / 2;
        self.layer.borderWidth = self.frame.height / 16;
        
        self.layer.backgroundColor = UIColor(red: 250.rgbd, green: 250.rgbd, blue: 250.rgbd, alpha: 0.85).cgColor;
        self.layer.borderColor = UIColor(red: 240.rgbd, green: 240.rgbd, blue: 240.rgbd, alpha: 0.9).cgColor;
        
    }
    
    /*// Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        var drawingRect = rect;
        
        // Ensure the rectangle we're passed is a square
        /*if rect.height != rect.width {
            if rect.height > rect.width {
                drawingRect.size.height = rect.width;
            }
            if rect.width > rect.height {
                drawingRect.size.width = rect.height;
            }
        }*/
        
        let circlePath = UIBezierPath(ovalIn: drawingRect);
        
        let shapeLayer = CAShapeLayer();
        shapeLayer.path = circlePath.cgPath;
        shapeLayer.fillColor = UIColor(red: 250.rgbd, green: 250.rgbd, blue: 250.rgbd, alpha: 0.85).cgColor;
        shapeLayer.strokeColor = UIColor(red: 240.rgbd, green: 240.rgbd, blue: 240.rgbd, alpha: 0.9).cgColor;
        shapeLayer.lineWidth = 4;
        
        layer.sublayers?.removeAll();
        layer.addSublayer(shapeLayer);
        
    }
    */
}
