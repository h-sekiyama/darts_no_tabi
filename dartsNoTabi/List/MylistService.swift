import Foundation
protocol MylistServiceProtocol {
    /// マイリストに追加
    /// - Parameter projectCd: プロジェクトCD
    func add(projectCd: String)

    /// マイリストから削除
    /// - Parameter projectCd: プロジェクトCD
    func delete(projectCd: String)

    /// マイリスト存在確認
    /// - Parameter projectCd: プロジェクトCD
    /// - Returns: 存在する場合true
    func exists(projectCd: String) -> Bool
}


class MylistService: MylistServiceProtocol {

    static let KEY = "mylist"

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func add(projectCd: String) {

        var mylists = (userDefaults.object(forKey: MylistService.KEY) as? [String]) ?? []

        if (!mylists.contains(projectCd)) {
            mylists.append(projectCd)
        }

        userDefaults.set(mylists, forKey: MylistService.KEY)
        userDefaults.synchronize()
    }

    func delete(projectCd: String) {

        var mylists = (userDefaults.object(forKey: MylistService.KEY) as? [String]) ?? []
        if let index = mylists.firstIndex(of: projectCd) {
            mylists.remove(at: index)
        }

        userDefaults.set(mylists, forKey: MylistService.KEY)
        userDefaults.synchronize()
    }

    func exists(projectCd: String) -> Bool {

        let mylists = (userDefaults.object(forKey: MylistService.KEY) as? [String]) ?? []

       return mylists.contains(projectCd)
    }
}


