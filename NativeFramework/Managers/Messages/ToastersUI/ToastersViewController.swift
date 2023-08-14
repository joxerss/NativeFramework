//
//  ToastersViewController.swift
//  SourceProject
//
//  Created by Artem Syrytsia on 21.07.2023.
//

import UIKit

final class ToastersViewController: UIViewController {
    
    // MARK: - Properies
    
    @IBOutlet private weak var tableView: HitTableView!
    
    private var toastersOnUI = Array<ToasterModel>()
    
    var router: ToastersRouter?
    
    // MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.invalidateIntrinsicContentSize()
    }
    
    static func instantiate(_ router: ToastersRouter) -> ToastersViewController {
        let nibName = String(describing: ToastersViewController.self)
        let viewController = ToastersViewController(nibName: nibName, bundle: Bundle(for: self))
        viewController.view.backgroundColor = .clear
        viewController.overrideUserInterfaceStyle = .light
        viewController.router = router
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .fullScreen
        view.backgroundColor = .clear
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: ToasterTextCell.identifier, bundle: Bundle(for: ToasterTextCell.self)),
                           forCellReuseIdentifier: ToasterTextCell.identifier)
        tableView.register(UINib(nibName: TosterCountdownCell.identifier, bundle: Bundle(for: TosterCountdownCell.self)),
                           forCellReuseIdentifier: TosterCountdownCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Public
    
    func showToaster(_ toaster: ToasterModel) {
        toastersOnUI.insert(toaster, at: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [.init(row: 0, section: 0)], with: .top)
        tableView.endUpdates()
    }
    
    func hideToaster(_ toaster: ToasterModel) {
        if let index = toastersOnUI.firstIndex(where: { $0 == toaster }) {
            toastersOnUI.remove(at: index)
            tableView.beginUpdates()
            tableView.deleteRows(at: [.init(row: index, section: 0)], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: - Private
    
    private func didTapOnTosterBody(_ model: ToasterModel) {
        router?.dismissToaster(model)
        model.action?()
    }

}

// MARK: - UITableViewDataSource

extension ToastersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toastersOnUI.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toaster = toastersOnUI[indexPath.row]
        
        switch toaster.type {
        case .text, .attributed(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: ToasterTextCell.identifier, for: indexPath) as! ToasterTextCell
            cell.setup(with: toaster)
            
            return cell
        case .countDown(_, _, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: TosterCountdownCell.identifier, for: indexPath) as! TosterCountdownCell
            cell.setup(with: toaster, hideCompletion: { [weak self] model in
                self?.router?.dismissToaster(model ?? toaster)
            }, crossCompletion: { [weak self] model in
                self?.didTapOnTosterBody(model ?? toaster)
            })
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UITableViewDelegate

extension ToastersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = toastersOnUI[indexPath.row]
        didTapOnTosterBody(model)
    }
    
}
