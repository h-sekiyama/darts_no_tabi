import Foundation
import UIKit

protocol ListDelegate: AnyObject {

    func didLoad()
//    func onReachBottom()
}

/// 一覧画面のデータソースのIF
protocol ListItemDataSource: AnyObject {
    /// フェッチされている一覧データの総数
    var numberOfItems: Int { get }

    /// 指定したインデックスのListPropertyViewModelを返す
    ///
    /// - Parameter at: ListPropertyViewModelのIndex
    func item(at: Int) -> ListPropertyViewModel?
}

class ListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var delegate: ListDelegate?
    var dataSource: ListTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .black
        
        edgesForExtendedLayout = []
        dataSource?.registerCells(to: tableView)
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = 100
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//            delegate?.onReachBottom()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
}

extension ListViewController {
    func reload() {
        tableView.reloadData()
    }
}
