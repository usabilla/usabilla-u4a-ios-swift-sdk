//
//  UBAccessibility.swift
//  Usabilla
//
//  Created by Adil Bougamza on 10/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBAccessibility {
    static let emoticonLabels: [String] = [
        LocalisationHandler.getLocalisedStringForKey("usa_mood_hate"),
        LocalisationHandler.getLocalisedStringForKey("usa_mood_dislike"),
        LocalisationHandler.getLocalisedStringForKey("usa_mood_neutral"),
        LocalisationHandler.getLocalisedStringForKey("usa_mood_like"),
        LocalisationHandler.getLocalisedStringForKey("usa_mood_love")]
    static let starLabels: [String] = [
        LocalisationHandler.getLocalisedStringForKey("usa_mood_one_star"),
        LocalisationHandler.getLocalisedStringForKey("usa_mood_two_star"),
        LocalisationHandler.getLocalisedStringForKey("usa_mood_three_star"),
        LocalisationHandler.getLocalisedStringForKey("usa_mood_four_star"),
        LocalisationHandler.getLocalisedStringForKey("usa_mood_five_star")]
}
