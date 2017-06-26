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

public enum Provider<Input, Output> {
    case constant(Output)
    case variable((Input) -> Output)

    public func value(for object: Input) -> Output {
        switch self {
        case .constant(let value): return value
        case .variable(let function): return function(object)
        }
    }
}

open class BaseDataSource<Element>: NSObject, UITableViewDataSource, UICollectionViewDataSource {
    public typealias CellCreator = ((Element, UIView?) -> (UIView, ContainerCellMode))
    public typealias SupplementCreator = ((String, UIView?) -> (UIView, ContainerCellMode))
    public typealias ChangeUpdater = (()->())
    
    public let reuseIDProvider: Provider<Element, String>
    public let cellCreator: CellCreator

    open var collection: [[Element]] = [[]] {
        didSet(oldValue) {
            notify()
        }
    }
    fileprivate var updateClosures: [ChangeUpdater] = []

    public init(_ collection: [[Element]], reuseIDProvider: Provider<Element, String>? = nil, cellCreator: @escaping CellCreator) {
        self.collection = collection
        self.reuseIDProvider = reuseIDProvider ?? .constant(UUID().uuidString)
        self.cellCreator = cellCreator
    }
    
    open func registerForChanges(_ closure: @escaping ChangeUpdater) {
        updateClosures += [closure]
    }
    
    // MARK: Collection Management
    
    open func lookUp(_ indexPath: IndexPath) -> Element {
        return collection[indexPath.section][indexPath.row]
    }
    
    open func remove(_ indexPath: IndexPath) -> Element {
        return collection[indexPath.section].remove(at: indexPath.row)
    }
    
    open func insert(_ object: Element, indexPath: IndexPath) {
        return collection[indexPath.section].insert(object, at: indexPath.row)
    }
    
    open func move(from: IndexPath, to: IndexPath) {
        let item: Element = remove(from)
        insert(item, indexPath: to)
    }
    
    // MARK: UITableViewDataSource
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.collection.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collection[section].count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = lookUp(indexPath)
        let reuseID = reuseIDProvider.value(for: object)
        return ContainerTableCell.cell(reuseID: reuseID, tableView: tableView, indexPath: indexPath, object: object, contentCreator: cellCreator)
    }
    
    // MARK: UICollectionViewDataSource
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.collection.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collection[section].count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = lookUp(indexPath)
        let reuseID = reuseIDProvider.value(for: object)
        return ContainerCollectionCell.cell(reuseID: reuseID, collectionView: collectionView, indexPath: indexPath, object: object, contentCreator: cellCreator)
    }
    
    // MARK: Helpers
    
    fileprivate func notify() {
        for closure in updateClosures {
            closure()
        }
    }
}
