//
//  ProteinListViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit
import SnapKit

protocol ProteinListViewControllerProtocol: AnyObject {
    func setLigands(_ ligands: [String], isFull: Bool)
    func showErrorPopup()
}

final class ProteinListViewController: UIViewController {
    
    private var isKeyboardUp = false
    private var ligands = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var fullLigands = [String]()
    
    private lazy var tableView = makeTableView()
    private lazy var sarchController = makeSearchController()
    
    private var presenter: ProteinListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchLigands()
        setupView()
        setConstraints()
        setKeyBoboardObservers()
        setNavigationBar()
    }
    
    func setupComponents(presenter: ProteinListPresenterProtocol) {
        self.presenter = presenter
    }
    
    private func setupView() {
        view.backgroundColor = Asset.primaryBackground.color
        view.addSubview(tableView)
    }
    
    private func setNavigationBar() {
        let imageView = UIImageView(image: Asset.moleculeMutipleColor.image)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: NavigationBarTitleView.width,
                height: NavigationBarTitleView.height
            )
        )
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
        navigationItem.searchController = sarchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func showPopup(popup: Popup) {
        view.addSubview(popup)
        setPopupConstraints(view: popup)
        UIView.animate(
            withDuration: 0.2,
            animations: {
                popup.alpha = 1
            },
            completion: { completion in
                if completion {
                    popup.showPopup()
                }
            }
        )
    }
}

extension ProteinListViewController: ProteinListViewControllerProtocol {
    
    func setLigands(_ ligands: [String], isFull: Bool) {
        self.ligands = ligands
        if isFull {
            self.fullLigands = ligands
        }
    }
    
    func showErrorPopup() {
        let popup = Popup(title: Text.Common.error, description: Text.Descriptions.failedToLoadLigands)
        popup.addButton(title: Text.Common.confirm, type: .custom, action: nil)
        popup.alpha = 0
        showPopup(popup: popup)
    }
}

extension ProteinListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ligands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProteinListTableViewCell.identifier, for: indexPath) as! ProteinListTableViewCell
        cell.nameLabel.text = ligands[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(
            ProteinConfigurator().setupModule(ligand: ligands[indexPath.row]),
            animated: true
        )
    }
}

extension ProteinListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              !text.isEmpty
        else {
            ligands = fullLigands
            return
        }
        presenter.searchLigandsInList(ligands: fullLigands, searchData: text)
    }
}

extension ProteinListViewController {
    
    private func setKeyBoboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !isKeyboardUp {
                setTableViewKeyboardUpConstraint(keyboardHeight: keyboardSize.height)
                isKeyboardUp = true
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if isKeyboardUp {
            setTableViewConstraints()
            isKeyboardUp = false
        }
    }
}

extension ProteinListViewController {
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProteinListTableViewCell.self, forCellReuseIdentifier: ProteinListTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorColor = Asset.darkBlueAndWhiteHalfTransparent.color
        return tableView
    }
    
    private func makeSearchController() -> UISearchController {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        return searchController
    }
}

extension ProteinListViewController {
    
    private func setConstraints() {
        setTableViewConstraints()
    }
    
    private func setTableViewConstraints() {
        tableView.snp.remakeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setPopupConstraints(view: UIView) {
        view.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setTableViewKeyboardUpConstraint(keyboardHeight: CGFloat) {
        tableView.snp.remakeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.bottom.equalToSuperview().inset(keyboardHeight)
            maker.leading.trailing.equalToSuperview()
        }
    }
}
