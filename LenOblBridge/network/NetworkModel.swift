
import Foundation

enum NetworkError: Error {
    case noData
}

class NetworkModel {
    
    func getBridges(onResult: @escaping (Result<[Bridge], Error>) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "http://188.119.67.67:3000/bridges")!
        let urlRequest = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let data = data else {
                onResult(.failure(NetworkError.noData))
                return
            }
            
            do {
                let bridgesResponse = try JSONDecoder().decode([Bridge].self, from: data)
                onResult(.success(bridgesResponse))
            }
            catch (let error) {
                print(error)
                onResult(.failure(error))
            }
            
        }
        dataTask.resume()
    }
    
}
