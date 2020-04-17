import UIKit
import SDWebImage

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var apidata = NSArray()
    var titlestring: String?
    var reach = Reach()
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
        view.addSubview(tableView)
        setupAutoLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        tableView.register(CustomCell.self, forCellReuseIdentifier: Constant.CellIdentifier)
        return tableView
    }()
    func setupAutoLayout() {

        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    @objc func refresh(sender:AnyObject) {
       getdata()
    }
    func getdata()
    {
        if reach.isConnectedToNetwork()
        {
            let url = Constant.Serverurl
            URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
                if let d = data {
                    if let value = String(data: d, encoding: String.Encoding.ascii) {
                        if let jsonData = value.data(using: String.Encoding.utf8) {
                            do {
                                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                                if let titlestring = json["title"] as? String {
                                    DispatchQueue.main.async {
                                        self.title = titlestring
                                    }
                                }
                                if let arr = json["rows"] as? [[String: Any]] {
                                    self.apidata = arr as NSArray
                                     DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.refreshControl.endRefreshing()
                                    }
                                }
                            } catch {
                                NSLog("ERROR \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }.resume()
        }
        else
        {
            let actionSheet = UIAlertController(title: "Internet Connection not Available!", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apidata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier, for: indexPath) as! CustomCell
        let dic = apidata.object(at: indexPath.row) as! NSDictionary
        let title = (dic.value(forKey: "title") as? String ?? "").isEmpty ? "Default" : dic.value(forKey: "title") as! String?
        let description = (dic.value(forKey: "description") as? String ?? "").isEmpty ? "Default" : dic.value(forKey: "description") as! String?
        let imageurl = (dic.value(forKey: "imageHref") as? String ?? "").isEmpty ? "Default" : dic.value(forKey: "imageHref") as! String?
        let url = URL(string: imageurl!)
        cell.lblTitle.text = title
        cell.lblDescription.text = description
        cell.imgcell.sd_setImage(with: url, placeholderImage:UIImage(named:"placeholder.png"))
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func networkStatusChanged(_ notification: Notification) {
           if let userInfo = notification.userInfo {
               let status = userInfo["Status"] as! String
            if status == "Offline" {
                tableView.isHidden = true
            } else {
                tableView.isHidden = false
            } } }
}

