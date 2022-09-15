//
//  ViewController.swift
//  NASA API
//
//  Created by roman Khilchenko on 15.09.2022.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let nasaURL = "https://api.nasa.gov/planetary/apod?api_key=YigFXbdhor1XgRdVXZmOolHFEpXsrWSCqh0UpF6G"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNasa()
    }
}

// MARK: - Networking
extension MainViewController {
    private func fetchNasa() {
        guard let url = URL(string: nasaURL) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let jsonDecoder = JSONDecoder()
            
            do {
                let nasa = try jsonDecoder.decode(Nasa.self, from: data)
                
                DispatchQueue.main.async {
                    print(nasa)
                    self.showAlert(status: .success)
                }
                
            } catch {
                
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self.showAlert(status: .failed)
                }
            }
        }
        task.resume()
    }
}


// MARK: - UiAlertController
extension MainViewController {
    private func showAlert(status: StatusAlert) {
        let alert = UIAlertController(
            title: status.title,
            message: status.message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Enums
private enum StatusAlert: String {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success: return "Success"
        case .failed: return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success: return  "You can see the results in the Debug aria"
        case .failed: return "You can see error in the Debug aria"
        }
    }
}
