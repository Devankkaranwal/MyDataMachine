//
//  PostViewModel.swift
//  MyDataMachine
//
//  Created by Devank on 03/05/24.
//

import Foundation

class PostViewModel {
    private var currentPage: Int = 1
    private var pageSize: Int = 10
    private var isFetching: Bool = false
    private var posts: [Post] = []
    private var detailCache: [Int: String] = [:] // Cache for detailed information
    
    var onDataUpdate: (() -> Void)?
    
    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(currentPage)&_limit=\(pageSize)") else {
            return
        }
        
        isFetching = true
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newPosts = try decoder.decode([Post].self, from: data)
                self?.posts.append(contentsOf: newPosts)
                
                DispatchQueue.main.async {
                    self?.onDataUpdate?()
                    self?.isFetching = false
                }
            } catch {
                print("Failed to decode data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
    
    func getPost(at index: Int) -> Post {
        return posts[index]
    }
    
    func loadMoreDataIfNeeded(for index: Int) {
        let lastElement = posts.count - 1
        if index == lastElement && !isFetching {
            currentPage += 1
            fetchPosts()
        }
    }
    
    func getDetail(for postId: Int, completion: @escaping (String) -> Void) {
        if let cachedDetail = detailCache[postId] {
            completion(cachedDetail)
            return
        }
        
        
        DispatchQueue.global().async {
            let detail = "Typicode Id \(postId)"
            
            self.detailCache[postId] = detail
            
            DispatchQueue.main.async {
                completion(detail)
            }
        }
    }
}
