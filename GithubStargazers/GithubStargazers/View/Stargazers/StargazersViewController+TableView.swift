
import UIKit

//MARK: - UITableViewDataSource
extension StargazersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stargazers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StargazersTableViewCell.identifier,
                                                       for: indexPath) as? StargazersTableViewCell
        else {
            return UITableViewCell()
        }
        
        let stargazer = viewModel.stargazers[indexPath.row]
        Task {
            let image = await viewModel.loadImage(from: stargazer.avatarURL)
            DispatchQueue.main.async {
                cell.configure(with: stargazer, image: image)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}
