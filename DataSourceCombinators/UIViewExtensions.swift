//               ~MMMMMMMM,.           .,MMMMMMM ..
//              DNMMDMMMMMMMM,.     ..MMMMNMMMNMMM,
//              MMM..   ...NMMM    MMNMM       ,MMM
//             NMM,        , MMND MMMM          .MM
//             MMN             MMMMM             MMM
//            .MM           , MMMMMM ,           MMM
//            .MM            MMM. MMMM           MMM
//            .MM~         .MMM.   NMMN.         MMM
//             MMM        MMMM: .M ..MMM        .MM,
//             MMM.NNMMMMMMMMMMMMMMMMMMMMMMMMMM:MMM,
//         ,,MMMMMMMMMMMMMMM           NMMDNMMMMMMMMN~,
//        MMMMMMMMM,,  OMMM             NMM  . ,MMNMMMMN.
//     ,MMMND  .,MM=  NMM~    MMMMMM+.   MMM.  NMM. .:MMMMM.
//    MMMM       NMM,MMMD   MMM$ZZZMMM:  .NMN.MMM        NMMM
//  MMNM          MMMMMM   MMZO~:ZZZZMM~   MMNMMN         .MMM
//  MMM           MMMMM   MMNZ~~:ZZZZZNM,   MMMM            MMN.
//  MM.           .MMM.   MMZZOZZZZZZZMM.   MMMM            MMM.
//  MMN           MMMMN   MMMZZZZZZZZZNM.   MMMM            MMM.
//  NMMM         .MMMNMN  .MM$ZZZZZZZMMN ..NMMMMM          MMM
//   MMMMM       MMM.MMM~  .MNMZZZZMMMD   MMM MMM .    . NMMN,
//     NMMMM:  ..MM8  MMM,  . MNMMMM:   .MMM:  NMM  ..MMMMM
//     ...MMMMMMNMM    MMM      ..      MMM.    MNDMMMMM.
//        .: MMMMMMMMMMDMMND           MMMMMMMMNMMMMM
//             NMM8MNNMMMMMMMMMMMMMMMMMMMMMMMMMMNMM
//            ,MMM        NMMMDMMMMM NMM.,.     ,MM
//             MMO        ..MMM    NMMM          MMD
//            .MM.         ,,MMM+.MMMM=         ,MMM
//            .MM.            MMMMMM~.           MMM
//             MM=             MMMMM..          .MMN
//             MMM           MMM8 MMMN.          MM,
//             +MMO        MMMN,   MMMMM,       MMM
//             ,MMMMMMM8MMMMM,      . MMNMMMMMMMMM.
//               .NMMMMNMM              DMDMMMMMM

import UIKit

public let maxUIElementDimension: CGFloat = 10000

internal extension UIView {

    internal func pinToSuperview(insets: UIEdgeInsets = UIEdgeInsets()) {
        guard let parent = superview else {
            NSLog("No parent view in `pinToSuperview`.")
            return
        }

        let views = ["view": self]
        let metrics = [
            "left": insets.left as AnyObject,
            "right": insets.right as AnyObject,
            "top": insets.top as AnyObject,
            "bottom": insets.bottom as AnyObject
        ]
        translatesAutoresizingMaskIntoConstraints = false
        parent.addConstraints(NSLayoutConstraint.visualConstraints(metrics: metrics, views: views, constraints: [
            "H:|-(left)-[view]-(right)-|",
            "V:|-(top)-[view]-(bottom)-|",
            ]))
    }

    internal func centerInSuperview() {
        centerVerticallyInSuperview()
        centerHorizontallyInSuperview()
    }

    internal func centerVerticallyInSuperview() {
        guard let parent = superview else {
            NSLog("No parent view in `centerHorizontallyInSuperview`.")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1, constant: 0))
    }

    internal func centerHorizontallyInSuperview() {
        guard let parent = superview else {
            NSLog("No parent view in `centerHorizontallyInSuperview`.")
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: 0))
    }
}

internal extension NSLayoutConstraint {

    internal class func visualConstraints(options: NSLayoutFormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: AnyObject], constraints: [String]) -> [NSLayoutConstraint] {
        return constraints.flatMap { NSLayoutConstraint.constraints(withVisualFormat: $0, options: options, metrics: metrics, views: views) }
    }
}
