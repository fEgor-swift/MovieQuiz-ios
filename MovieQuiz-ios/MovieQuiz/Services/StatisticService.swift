import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard

    // Свойство для хранения общего количества правильных ответов
    private var correctAnswers: Int {
        get {
         
            return UserDefaults.standard.integer(forKey: "correctAnswers")
        }
        set {
    
            UserDefaults.standard.set(newValue, forKey: "correctAnswers")
        }
    }
    
    // Свойство для хранения общего количества вопросов
    private var totalQuestions: Int {
        get {
           
            return UserDefaults.standard.integer(forKey: "totalQuestions")
        }
        set {
           
            UserDefaults.standard.set(newValue, forKey: "totalQuestions")
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
          
            return UserDefaults.standard.integer(forKey: "gamesCountKey")
        }
        set {
          
            UserDefaults.standard.set(newValue, forKey: "gamesCountKey")
        }
    }
    
    // Хранение и возврат топ результата игры
    var bestGame: GameResult {
        get {
            // Чтение лучшего результата из UserDefaults
            let correct = UserDefaults.standard.integer(forKey: "bestGameCorrect")
            let total = UserDefaults.standard.integer(forKey: "bestGameTotal")
            let storedDate = UserDefaults.standard.object(forKey: "bestGameDate")
            
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
            UserDefaults.standard.set(newValue.correct, forKey: "bestGameCorrect")
            UserDefaults.standard.set(newValue.total, forKey: "bestGameTotal")
            UserDefaults.standard.set(newValue.date, forKey: "bestGameDate")
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
