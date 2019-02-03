import UIKit
import GoogleMobileAds

class ViewControllerWithAdMob: UIViewController, GADBannerViewDelegate {
    var adBannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        addBannerViewToView(adBannerView)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "5fc46f5579c1c56ef8095e225e129b50", "ea7f9c89c5902146fdb69f3adf34b238"]
        adBannerView.adUnitID = "ca-app-pub-3679599074148025/7729845973"
        adBannerView.rootViewController = self
        adBannerView.delegate = self
        adBannerView.load(GADRequest())
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    // Ad delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Received Ad")
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("Will present Ad.")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed, error: \(error.description)")
    }
}
