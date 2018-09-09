//
//  GIFView.swift
//  GoofyGiphyCamera
//
//  Created by Brendan Manning on 9/8/18.
//  Copyright © 2018 Brendan Manning. All rights reserved.
//

import SwiftyGif
import UIKit

class GIFView: UIImageView {

    static let INTENDED_SIZE = CGSize(width: 300, height: 175);

    var panGesture = UIPanGestureRecognizer();
    
    init(keyPoint: CGPoint) {
        super.init(frame: CGRect(x: keyPoint.x, y: keyPoint.y, width: GIFView.INTENDED_SIZE.width, height: GIFView.INTENDED_SIZE.height));
    }
    
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
        self.alpha = 0;
        self.frame.size = GIFView.INTENDED_SIZE;
        
    }
    
    func enableGestures(target: UIViewController, selector: Selector) {
        panGesture = UIPanGestureRecognizer(target: target, action: selector);
        self.isUserInteractionEnabled = true;
        self.addGestureRecognizer(panGesture);
    }
    
    func show(gif: URL) {
        self.setGifFromURL(gif);
        
        // Animate in the view
        self.frame.size.height = GIFView.INTENDED_SIZE.height * 1.25;
        self.frame.size.width = GIFView.INTENDED_SIZE.width * 1.25;
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1;
            self.frame.size.height = GIFView.INTENDED_SIZE.height;
            self.frame.size.width = GIFView.INTENDED_SIZE.width;
        })
    }
}
