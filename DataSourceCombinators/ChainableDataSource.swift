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

open class ChainableDataSource<Element>: BaseDataSource<Element> {
    open fileprivate(set) var dataSource: ChainableDataSource?
    
    override public init(_ collection: [[Element]], reuseIDProvider: Provider<Element, String>? = nil, cellCreator: @escaping CellCreator) {
        super.init(collection, reuseIDProvider: reuseIDProvider, cellCreator: cellCreator)
    }
    
    public init(dataSource: ChainableDataSource) {
        self.dataSource = dataSource
        super.init(dataSource.collection, reuseIDProvider: dataSource.reuseIDProvider, cellCreator: dataSource.cellCreator)
    }
    
    // MARK: Forwarded UITableViewDataSource

    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let dataSource = dataSource {
            return dataSource.sectionIndexTitles(for: tableView)
        }

        return []
    }

    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.tableView(tableView, sectionForSectionIndexTitle: title, at: index)
        }

        return 0
    }

    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let dataSource = dataSource {
            return dataSource.tableView(tableView, titleForHeaderInSection: section)
        }

        return nil
    }

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let dataSource = dataSource {
            return dataSource.tableView(tableView, titleForFooterInSection: section)
        }
        
        return nil
    }

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let dataSource = dataSource {
            return dataSource.tableView(tableView, canEditRowAt: indexPath)
        }

        return false
    }

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let dataSource = dataSource {
            return dataSource.tableView(tableView, canMoveRowAt: indexPath)
        }

        return false
    }

    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let dataSource = dataSource {
            dataSource.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
        }
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let dataSource = dataSource {
            dataSource.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
    }
}
