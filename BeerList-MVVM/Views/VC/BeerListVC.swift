//
//  BeerListVC.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class BeerListVC: UIViewController {
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let disposeBag = DisposeBag()
    private let viewModel = BeerListViewModel()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<BeerListSection>(configureCell: {  (_, tableView, _, beer) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell") as? BeerTableViewCell ?? BeerTableViewCell(style: .default, reuseIdentifier: "BeerTableViewCell")
        cell.setupView(model: beer)
        return cell
    })
    //MARK: Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupNavigationTitle()
    }
    //MARK: Private Methods
    private func setupSubview() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        tableView.addSubview(refreshControl)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "BeerList"
        self.navigationItem.accessibilityLabel = "BeerList"
    }
    
    private func bindViewModel() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refreshTrigger)
            .disposed(by: disposeBag)
        
        viewModel.output.list
            .map { [BeerListSection(header: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isRefreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
//        viewModel.output.errorRelay
//            .subscribe(onNext: { [weak self] error in
//                print(error.localizedDescription)
//                
//            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Beer.self)
            .subscribe(onNext: { [weak self] beer in
                let controller = DetailBeerVC(beer: beer)
                self?.navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] row in
                self?.tableView.deselectRow(at: row, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.reachedBottom(offset: 120.0)
            .bind(to: viewModel.input.nextPageTrigger)
            .disposed(by: disposeBag)
    }
}

