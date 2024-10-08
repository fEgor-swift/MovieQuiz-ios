
import Foundation
/// Отвечает за загрузку данных по URL

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}


struct NetworkClient: NetworkRouting {

    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        print("Получение данных из URL: \(url.absoluteString)")
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                print("Получен неверный код ответа: \(response.statusCode)")
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else {
                print("Данные не получены")
                handler(.failure(NetworkError.codeError))
                return
            }
            
            print("Данные успешно получены")
            handler(.success(data))
        }
        
        task.resume()
    }
}
