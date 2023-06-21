//
//  ArtistDetailWidgetBundle.swift
//  ArtistDetailWidget
//
//  Created by Andrés Murillas on 21/6/23.
//

import WidgetKit
import SwiftUI

@main
struct ArtistDetailWidgetBundle: WidgetBundle {
    var body: some Widget {
        ArtistDetailWidget()
        ArtistDetailWidgetLiveActivity()
    }
}
