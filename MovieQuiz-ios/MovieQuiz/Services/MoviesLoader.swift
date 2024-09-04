
import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/MostPopularTVs/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        print("URL: \(url)")
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                print("Получены необработанные данные: \(String(data: data, encoding: .utf8) ?? "nil")")
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    
                    // Проверка на наличие ошибки в ответе
                    if mostPopularMovies.errorMessage.isEmpty {
                       
                        handler(.success(mostPopularMovies))
                    } else {
                        print("Ошибка сервера: \(mostPopularMovies.errorMessage)")
                        handler(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: mostPopularMovies.errorMessage])))
                    }
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription)")
                    handler(.failure(error))
                }
            case .failure(let error):
                print("Ошибка сети: \(error.localizedDescription)")
                handler(.failure(error))
            }
        }
    }
}
