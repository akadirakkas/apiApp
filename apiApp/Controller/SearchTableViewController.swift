//
//  ViewController.swift
//  apiApp
//
//  Created by AbdulKadir Akkaş on 15.03.2021.
//

import UIKit
import Combine
import  MBProgressHUD

class SearchTableViewController: UITableViewController  , UIAnimatable{
    
    
    private enum Mode {
        case onboarding
        case search
    
    }
    
    private lazy var searchController : UISearchController = {
        let sc  = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
        
    }()
    
    private let apiService = APIServices()
    private var subscribers = Set<AnyCancellable>()
    private var searchResults :  SearchResults?
    @Published private var mode : Mode = .onboarding
    @Published private var  searchQuery = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        observeForm()
    }
    
    

    
    private func setupNavigationBar(){
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
        
    }
    private func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    
    
    private func observeForm() {
    //Apiye istek atmadan önce beklediği süre
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self](searchQuery) in
                showLoadingAnimation()
            self.apiService.fetchSymbolsPuplisher(keywords: searchQuery)
                .sink {(completion) in
                    hideLoadingAnimation()
                switch completion{
                case .failure(let error) :
                    print(error.localizedDescription)
                case .finished : break
                }
            } receiveValue: { (searchResults) in
                self.searchResults = searchResults
                self.tableView.reloadData()
            }.store(in: &self.subscribers)
        }.store(in: &subscribers)
        
        
        $mode.sink {[unowned self] (mode) in
            switch mode {
            case .onboarding :
                self.tableView.backgroundView = SearchPlaceHolderView()
            case .search :
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    
    }
    
    

}
extension SearchTableViewController : UISearchResultsUpdating , UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text , !searchQuery.isEmpty else {return}
        self.searchQuery = searchQuery
    }
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
    
    
}

extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.item.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        if let searchResults = self.searchResults {
            let searchResult = searchResults.item[indexPath.row]
            cell.configure(with: searchResult)
        }
       
        return cell
    }
}
