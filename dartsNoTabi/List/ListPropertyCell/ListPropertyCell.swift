import UIKit

class ListPropertyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // xibで設定済みでも反映されないことがあるため、コードで設定しています。
        backgroundColor = .clear
    }
    
    /// 表示更新
    ///
    /// - Parameter vm: ViewModel
    func configure(with vm: ListPropertyViewModel) {
        nameLabel.text = vm.name
    }
}
