import Foundation

class NavigationTableViewController<T: NavigationScreenDataSource>: UITableViewController where T: CaseIterable {
    private var dataSource = Array(T.allCases)

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cellModel = dataSource[indexPath.row]
        cell.textLabel?.text = cellModel.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = dataSource[indexPath.row]
        navigationController?.pushViewController(cellModel.destinationViewController, animated: true)
    }
}
