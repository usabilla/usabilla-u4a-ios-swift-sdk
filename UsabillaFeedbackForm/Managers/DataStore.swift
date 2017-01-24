//
//  DataStore
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class DataStore {
    private static let feedbackToSendStorePath = "com.usabilla.u4a.feedback.to.send"
    typealias FeedbackType = FeedbackRequest
    static let shared = DataStore()
    
    private(set) var feedbacks: [FeedbackType] = []

    init() {
        if let storedFeedbacks = UserDefaults.standard.value(forKey: DataStore.feedbackToSendStorePath) as? [[String: AnyObject]] {
            feedbacks = storedFeedbacks.map{FeedbackType(data: $0)}
        } else {
            feedbacks = []
        }
    }
    
    func removeFeedback(index: Int) {
        feedbacks.remove(at: index)
        saveFeedbacks()
    }
    
    func addFeedback(type: FeedbackType) {
        feedbacks.append(type)
        saveFeedbacks()
    }

    private func saveFeedbacks() {
        UserDefaults.standard.set(feedbacks.map{$0.encode()}, forKey: DataStore.feedbackToSendStorePath)
    }
}
