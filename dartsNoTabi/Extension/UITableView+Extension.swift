import UIKit
extension UITableView {

    /// xibで作成したUITableViewCellをクラスと同名のxibファイル登録してregister。reuseIdentifierはクラス名になります。
    ///
    /// - Parameter nibCellClass: xibで作成したUITableViewCell
    func register(nibCellClass: AnyClass) {
        register(UINib(forClass: nibCellClass),
                 forCellReuseIdentifier: nibCellClass.description())
    }

    /// 引数で指定した型でcellをdequeue。reuseIdentifierは渡したセルのクラス名になります。
    ///
    /// - Parameter type: cellの型
    /// - Returns: dequeueされたcellインスタンス
    /// - Note: Registerされてないクラスを登録するとクラッシュします。
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.description()) as? T else {
            fatalError("Could not dequeue cell with identifier: \(type.description())")
        }
        return cell
    }
}
