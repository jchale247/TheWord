//
//  TheWordHomeWidgetBundle.swift
//  TheWordHomeWidget
//
//  Created by Joseph on 5/6/25.
//

import WidgetKit
import SwiftUI

@main
struct TheWordHomeWidgetBundle: WidgetBundle {
    var body: some Widget {
        TheWordHomeWidget()
        TheWordHomeWidgetControl()
        TheWordHomeWidgetLiveActivity()
    }
}
