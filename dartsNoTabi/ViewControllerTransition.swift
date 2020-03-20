import UIKit
@objc
public protocol ViewControllerTransition: class {

    func push(_ vc: UIViewController, animated: Bool)
    func present(_ vc: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
    @objc(dismissViewControllerAnimated:completion:)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension UIViewController: ViewControllerTransition {

    public func push(_ vc: UIViewController, animated: Bool) {
        navigationController?.pushViewController(vc, animated: animated)
    }

    public func present(_ vc: UIViewController, animated: Bool) {
        present(vc, animated: animated, completion: nil)
    }

    public func pop(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }

    public func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
}
