//
//  Onboarding.swift
//  GoofyGiphyCamera
//
//  Created by Brendan Manning on 9/9/18.
//  Copyright © 2018 Brendan Manning. All rights reserved.
//

import BLTNBoard
import UIKit

class Onboarding: NSObject {
    static func firstCard() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Welcome");
        page.image = UIImage(named: "LaunchIcon");
        page.descriptionText = "Turn a picture into an infinite stream of random gifs";
        page.actionButtonTitle = "Continue";
        return page;
    }
}
