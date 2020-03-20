import Foundation
import UIKit

protocol MainDelegate: AnyObject {
    func didLoad()
    
    func willAppear()
}

protocol MainView: AnyObject {
    func setText(_ text: String)
}

private func makeDelegate() -> MainPresenter {
    let view = MainViewController()
    let presenter = MainPresenter(view: view)
    return presenter
}

private func setupEvent() {
}

class MainViewController: UIViewController {
    
    @IBAction func gotoDetailButton(_ sender: Any) {
        ListRouter().push(from: self, entry: ListEntryEntity(propertyType: .tokyo))
    }
    var delegate: MainDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = makeDelegate()
        setupEvent()
        
        delegate?.didLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.willAppear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainViewController: MainView {    
    func setText(_ text: String) {
        
    }
}
