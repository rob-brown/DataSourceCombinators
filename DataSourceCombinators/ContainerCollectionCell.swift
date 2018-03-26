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

public final class ContainerCollectionCell<T>: UICollectionViewCell {

    public typealias SimpleContentCreator = () -> CellContent
    public typealias ContentCreator = (T, UIView?) -> CellContent

    private var object: T?
    private weak var view: UIView?

    public class func cell(reuseID: String, collectionView: UICollectionView, indexPath: IndexPath, object: T, contentCreator: ContentCreator) -> UICollectionViewCell {
        register(reuseID: reuseID, collectionView: collectionView)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)

        guard let containerCell = cell as? ContainerCollectionCell else { return cell }

        containerCell.object = object
        containerCell.addContentView(object: object, contentCreator: contentCreator)

        return containerCell
    }

    public class func cell(reuseID: String, collectionView: UICollectionView, indexPath: IndexPath, contentCreator: SimpleContentCreator) -> UICollectionViewCell {
        return ContainerCollectionCell<Void>.cell(reuseID: reuseID, collectionView: collectionView, indexPath: indexPath, object: ()) { _,_  in
            return contentCreator()
        }
    }

    private class func register(reuseID: String, collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: reuseID)
    }

    private func addContentView(object: T, contentCreator: ContentCreator) {
        let oldView = view
        oldView?.removeFromSuperview()

        let content = contentCreator(object, oldView)
        contentView.addSubview(content.view)

        switch content.mode {
        case .fill:
            content.view.pinToSuperview()
        case .center:
            content.view.centerInSuperview()
        case let .inset(insets):
            content.view.pinToSuperview(insets: insets)
        }

        view = content.view
        content.style.forEach(apply(option:))
    }

    private func apply(option: StyleOption) {
        switch option {
        case .backgroundColor(let color):
            backgroundColor = color
            contentView.backgroundColor = color
        }
    }
}
