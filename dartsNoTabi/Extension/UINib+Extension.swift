import UIKit

extension UINib {

    convenience init(forClass clazz: AnyClass) {
        let typeName = String(describing: clazz)
        self.init(nibName: typeName,
                  bundle: Bundle(for: clazz))
    }

}
