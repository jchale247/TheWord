import WidgetKit
import SwiftUI

// This file should only define the widget's configuration, not have @main.
@available(iOS 14.0, *)
struct VerseWidgetBundle: WidgetBundle {
    var body: some Widget {
        VerseWidget() // Referencing the widget here, but no @main attribute.
    }
}
