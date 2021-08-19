//
//  ViewController.swift
//  GLSubModule
//
//  Created by Kathy on 2021/8/18.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "通讯录"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightClick))
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新", attributes: nil)
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
        loadNewData()
        tableView.tableFooterView = UIView()
    }
    
    @objc func refreshTableView() -> () {
        loadNewData()
    }
    
    func loadNewData() {
        self.dataArray = (GLCoreDataManager.shared.fetchData(with: "User", predicate: nil) as? [User]) ?? [User]()
        self.tableView.reloadData()
        endRefresh()
    }
    
    func endRefresh() -> () {
        DispatchQueue.main.async {
            if self.tableView.refreshControl?.isRefreshing ?? false {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func rightClick() {
        let vc = AddUserViewController()
        vc.completion = { [weak self] in
            self?.loadNewData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    var dataArray:[User] = [User]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let user = self.dataArray[indexPath.row]
        cell?.textLabel?.text = user.name
        cell?.detailTextLabel?.text = user.phone
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action1 = UITableViewRowAction(style: .normal, title: "编辑") {[weak self] action, indexPath in
            self?.editData(indexPath.row)
        }
        let action2 = UITableViewRowAction(style: .destructive, title: "删除") {[weak self] action, indexPath in
            self?.deleteData(indexPath.row)
        }
        return [action2, action1]
    }
    
    func deleteData(_ index: Int) {
        let user = self.dataArray[index]
        GLCoreDataManager.shared.persistentContainer.viewContext.delete(user)
        GLCoreDataManager.shared.saveContext()
        self.dataArray.remove(at: index)
        self.tableView.reloadData()
    }
    
    func editData(_ index: Int) {
        let vc = AddUserViewController()
        vc.user = self.dataArray[index]
        vc.completion = { [weak self] in
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

