import Foundation
import StoreKit

class ReviewRequester {
    static let appRunTimesKey = "app_run_times"
    static let reviewRequestedKey = "review_requested"
    static let requestReviewAtRun = 10
    
    static func checkForRequest() {
        let requested = UserDefaults.standard.bool(forKey: reviewRequestedKey)
        let runTime = UserDefaults.standard.integer(forKey: appRunTimesKey)
        if !requested && runTime > requestReviewAtRun {
            SKStoreReviewController.requestReview()
            UserDefaults.standard.set(true, forKey: reviewRequestedKey)
        }
    }
    
    static func incrementRuns() {
        let runTime = UserDefaults.standard.integer(forKey: appRunTimesKey)
        UserDefaults.standard.set(runTime + 1, forKey: appRunTimesKey)
    }
}
