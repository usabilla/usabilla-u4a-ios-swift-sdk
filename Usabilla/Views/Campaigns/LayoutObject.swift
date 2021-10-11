//
//  LayoutObject.swift
//  BannerPagerTester
//
//  Created by Anders Liebl on 27/10/2021.
//

import Foundation

struct LayoutObject: Codable {
    var backgroundColor:String = "#34542380"
    var clickable: Bool = true
    var card: BannerObject = BannerObject()
}

struct BannerObject: Codable {
    var marginTop: Float = 40
    var marginLeading: Float = 40
    var marginTrailing: Float = 40
    var marginBottom: Float = 40

}
