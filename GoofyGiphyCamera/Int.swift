//
//  Integer.swift
//  GoofyGiphyCamera
//
//  Created by Brendan Manning on 9/8/18.
//  Copyright © 2018 Brendan Manning. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var rgbd : CGFloat {
        get {
            return CGFloat(Double(self) / 255.0);
        }
    }
}
