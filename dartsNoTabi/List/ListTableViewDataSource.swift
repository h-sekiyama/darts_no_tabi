import UIKit

private func itemCell(
    tableView: UITableView,
    item: ListPropertyViewModel?) -> UITableViewCell {
    guard let item = item else {
        return UITableViewCell()
    }

    let cell = tableView.dequeueReusableCell(type: ListPropertyCell.self)
    cell.configure(with: item)
    return cell

}

class ListTableViewDataSource: NSObject {
    
    private var dataSource: ListItemDataSource
    
    init(dataSource: ListItemDataSource) {
        self.dataSource = dataSource
    }
    
    /// セルをtableViewにregister
    ///
    /// - Parameter tableView: 登録するtableView
    func registerCells(to tableView: UITableView) {
        tableView.register(nibCellClass: ListPropertyCell.self)
    }
}

extension ListTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return itemCell(
            tableView: tableView,
            item: dataSource.item(at: indexPath.row))
    }
    
    
}
