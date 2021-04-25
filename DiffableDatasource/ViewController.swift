//
//  ViewController.swift
//  DiffableDatasource
//
//  Created by Shyam Kumar on 4/25/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate {

    enum Section {
        case first
    }
    
    struct Fruit: Hashable {
        let title: String
    }
    @IBOutlet weak var tblV: UITableView!
    var datasource: UITableViewDiffableDataSource<Section, Datum>!
    var fruits = [Fruit]()
    
    var users = [Users]()
    var user = [Datum]()
    
    override func viewWillAppear(_ animated: Bool) {
        apiCall(completion: { bool in
            if bool {
                self.updateDatasource()
            }
            
        })
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.datasource = UITableViewDiffableDataSource(tableView: self.tblV, cellProvider: { (tblV, indexPath, usersss) -> UITableViewCell? in

            let cell = tblV.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            print(indexPath)
           
            cell.textLabel?.text = usersss.firstName
            
//            cell.textLabel?.text = "\(String(describing: usersss.data?.compactMap({$0.firstName})))"
            
            return cell

        })


        tblV.delegate = self
        
        title = "My Fruits"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd))
    }


    
    func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Datum>()
        snapshot.appendSections([.first])
        
        snapshot.appendItems(user)
 
        
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let user = datasource.itemIdentifier(for: indexPath) else {
            return
        }
        
        

    }

    func apiCall(completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://reqres.in/api/users?page=2")
        
//        let url = URL(string: "https://jsonplaceholder.typicode.com/users")

        
        AF.request(url!, method: .get).responseJSON { (res) in
            print(res)
            
            do {
            let data = try JSONDecoder().decode(Users.self, from: res.data ?? Data())
                self.users.append(data)
                self.user = data.data!
               completion(true)
            } catch (let err){
                print(err)
            }
            
        }
        
        
    }
    
}

