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
    private static let dataStoreSerialQueue = DispatchQueue(label: "com.usabilla.u4a.datastore")

    typealias FeedbackType = FeedbackRequest

    static var feedbacks: [FeedbackType] = {
        if let storedFeedbacks = UserDefaults.standard.value(forKey: DataStore.feedbackToSendStorePath) as? [[String: AnyObject]] {
            return storedFeedbacks.map { FeedbackType(data: $0) }
        } else {
            return []
        }
    }()

    static func removeFeedback(index: Int) {
        dataStoreSerialQueue.sync {
            if feedbacks.count > index {
                feedbacks.remove(at: index)
                saveFeedbacks()
            }
        }
    }

    static func addFeedback(type: FeedbackType) {
        dataStoreSerialQueue.sync {
            feedbacks.append(type)
            saveFeedbacks()
        }
    }

    static private func saveFeedbacks() {
        UserDefaults.standard.set(feedbacks.map { $0.encode() }, forKey: DataStore.feedbackToSendStorePath)
    }
}
