//
//  DetailViewController.swift
//  MyDataMachine
//
//  Created by Devank on 03/05/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var postId: Int!
    var titleText: String!
    var viewModel: PostViewModel!
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
          super.viewDidLoad()
          viewModel.getDetail(for: postId) { [weak self] detail in
              self?.detailLabel.text = detail
          }
          titleLabel.text = titleText
      }

}
