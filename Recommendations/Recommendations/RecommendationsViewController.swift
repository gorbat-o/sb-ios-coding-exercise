//
//  ViewController.swift
//  Recommendations
//

import UIKit
import OHHTTPStubs

final class RecommendationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var storageManager = StorageManager()
    private var networkManager = NetworkManager()
    private var recommendations = [Recommendation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadCachedData { [weak self] in
            self?.loadData()
        }
    }
}

private extension RecommendationsViewController {
    func setupTableView() {
        tableView.register(UINib(nibName: "RecommendationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: RecommendationTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }

    func loadCachedData(callbackDone: @escaping () -> Void) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            if let retrievedTitles = self?.storageManager.retrieveTitles() {
                self?.recommendations = self?.filterTitles(with: retrievedTitles) ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    callbackDone()
                }
            } else {
                DispatchQueue.main.async {
                    callbackDone()
                }
            }
        }
    }

    func loadData() {
        // ---------------------------------------------------
        // -------- <DO NOT MODIFY INSIDE THIS BLOCK> --------
        // stub the network response with our local ratings.json file
        let stub = Stub()
        stub.registerStub()
        // -------- </DO NOT MODIFY INSIDE THIS BLOCK> -------
        // ---------------------------------------------------

        networkManager.getTitles(with: stub) { [weak self] (returnedTitles, returnedError) in
            if let error = returnedError {
                print(error)
                // Show error
            } else if let titles = returnedTitles {
                self?.storageManager.store(titles: titles)
                self?.recommendations = self?.filterTitles(with: titles) ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    func filterTitles(with titles: Titles) -> [Recommendation] {
        let arraySliced = titles.titles
            .filter({ $0.isReleased && !titles.skipped.contains($0.title) && !titles.titles_owned.contains($0.title) })
            .sorted(by: { $0.rating ?? 0.0 > $1.rating ?? 0.0 })
            .prefix(10)
        return Array(arraySliced)
    }
}

extension RecommendationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationTableViewCell.identifier,
                                                 for: indexPath) as? RecommendationTableViewCell
        cell?.setup(with: recommendations[indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendations.count
    }
}
