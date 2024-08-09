//
//  ViewController.swift
//  iTunes
//
//  Created by 최승범 on 8/8/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import SnapKit

final class ViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        binding()
    }


}

extension ViewController {
    
    private func binding() {
        
        let input = SearchViewModel.Input(searchText: searchBar.rx.text.orEmpty,
                                          searchButtonClicked: searchBar.rx.searchButtonClicked)
        
        let output = viewModel.transform(input: input)
        
        output.list.bind(to: tableView.rx.items(cellIdentifier: SearchResultCell.identifier,
                                                cellType: SearchResultCell.self)) {row,elemet,cell in
            cell.appNameLabel.text = elemet.trackName
            cell.appIconImageView.kf.setImage(with: URL(string: elemet.artworkUrl100))
            
        }.disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(SearchResult.self)
            .bind(with: self) { owner, value in
                owner.navigationController?.pushViewController(AppDetailViewController(), animated: true)
            }
        
    }
    
}

//MARK: - Configuration
extension ViewController: BaseViewProtocol {
    
    func configureNavigationBar() {
        
        navigationItem.titleView = searchBar
    }
    
    func configureHierarchy() {
        
        view.addSubview(tableView)
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        tableView.rowHeight = 100
        tableView.register(SearchResultCell.self,
                           forCellReuseIdentifier: SearchResultCell.identifier)
    }
    
    func configureLayout() {
        
        tableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
