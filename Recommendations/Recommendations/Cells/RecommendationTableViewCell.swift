//
//  RecommendationTableViewCell.swift
//  Recommendations
//

import UIKit

final class RecommendationTableViewCell: UITableViewCell {
    @IBOutlet weak var recommendationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    private var urlSessionDataTask: URLSessionDataTask?

    func setup(with recommendation: Recommendation) {
        titleLabel.text = recommendation.title
        taglineLabel.text = recommendation.tagline
        ratingLabel.text = "Rating: \(recommendation.rating ?? 0.0)"
        loadImage(with: recommendation.imageURL)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        resetView()
    }
}

private extension RecommendationTableViewCell {
    func resetView() {
        titleLabel.text = ""
        taglineLabel.text = ""
        ratingLabel.text = ""
        recommendationImageView.image = nil
        urlSessionDataTask?.cancel()
        urlSessionDataTask = nil
    }

    // TODO: We could definitily improve that by create a wrapper or having an extension in UIImageView
    func loadImage(with imageURL: String) {
        if let url = URL(string: imageURL) {
            urlSessionDataTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self?.recommendationImageView?.image = image
                    }
                }
            })
            urlSessionDataTask?.resume()
        }
    }
}
