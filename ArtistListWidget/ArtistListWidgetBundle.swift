//
//  ArtistListWidgetBundle.swift
//  ArtistListWidget
//
//  Created by Andrés Murillas on 18/7/23.
//

import WidgetKit
import SwiftUI

@main
struct ArtistListWidgetBundle: WidgetBundle {
    var body: some Widget {
        ArtistListWidget()
        ArtistListWidgetLiveActivity()
    }
}
