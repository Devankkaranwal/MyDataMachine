//
//  ViewController.swift
//  MyDataMachine
//
//  Created by Devank on 03/05/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate {
    
  private var viewModel: PostViewModel!
  private var isLoading = false //--loader
  var loaderView = UIActivityIndicatorView(style: .large)
    
 @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
           super.viewDidLoad()
        navigationItem.title = "Typicode"
           
           viewModel = PostViewModel()
           viewModel.onDataUpdate = { [weak self] in
               self?.tableView.reloadData()
               self?.isLoading = false
               self?.loaderView.stopAnimating()
           }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
           tableView.dataSource = self
           tableView.delegate = self
           
           viewModel.fetchPosts()
       }
    
    // TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.getPostsCount()
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
            let post = viewModel.getPost(at: indexPath.row)
            cell.textLabel?.text = post.title
            //cell.detailTextLabel?.text = post.body
            return cell
        }
        
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           if indexPath.row == viewModel.getPostsCount() - 1 && !isLoading {
               isLoading = true
               loaderView.startAnimating()
               tableView.tableFooterView = loaderView
               tableView.tableFooterView?.isHidden = false
               viewModel.loadMoreDataIfNeeded(for: indexPath.row)
           }
       }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = viewModel.getPost(at: indexPath.row).id
        let titleText = viewModel.getPost(at: indexPath.row).title
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.postId = postId
            detailVC.titleText = titleText
            detailVC.viewModel = viewModel
        
            navigationController?.pushViewController(detailVC, animated: true)
         
        }
    }



   
}
