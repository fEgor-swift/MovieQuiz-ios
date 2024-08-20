import Foundation


final class StatisticService {
    
    
    private enum Keys: String {
                case correctAnswers
                case totalQuestions
                case gamesCount
                case bestGameCorrect
                case bestGameTotal
                case bestGameDate
    }
    
    private let storage: UserDefaults = .standard

    // Свойство для хранения общего количества правильных ответов
    private var correctAnswers: Int {
       
        get {
            return storage.integer(forKey: Keys.correctAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
        }
    }
    
    // Свойство для хранения общего количества вопросов
    private var totalQuestions: Int {
        get {
           
            return storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
           
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
        }
    }
    
}

extension StatisticService: StatisticServiceProtocol {
    
    // Вычисляет среднюю точность ответов в процентах
    var totalAccuracy: Double {
       
        guard totalQuestions > 0 else { return 0.0 }
        
        let accuracy = (Double(correctAnswers) / Double(totalQuestions)) * 100
        return accuracy
    }
    
    // Хранение и возврат количества игр
    var gamesCount: Int {
        get {
          
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
          
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // Хранение и возврат топ результата игры
    var bestGame: GameResult {
        get {
            // Чтение лучшего результата из UserDefaults
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let storedDate = storage.object(forKey: Keys.bestGameCorrect.rawValue)
            
            // Проверка даты из UserDefaults
            let date: Date
            if let unwrappedDate = storedDate as? Date {
                date = unwrappedDate
            } else {
               
                date = Date()
            }
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            // Сохранение нового лучшего результата в UserDefaults
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameCorrect.rawValue)
        }
    }
    
    // Сохраняет данные о текущей игре и обновляет статистику
    func store(correct count: Int, total amount: Int) {
      
        correctAnswers += count
        totalQuestions += amount
        
       
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
       
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
        
    
        gamesCount += 1
    }
}
