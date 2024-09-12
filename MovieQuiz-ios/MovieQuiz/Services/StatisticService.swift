import Foundation

final class StatisticService: StatisticServiceProtocol {

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
        get { return storage.integer(forKey: Keys.correctAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.correctAnswers.rawValue) }
    }

    // Свойство для хранения общего количества вопросов
    private var totalQuestions: Int {
        get { return storage.integer(forKey: Keys.totalQuestions.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalQuestions.rawValue) }
    }

    // Вычисляет среднюю точность ответов в процентах
    var totalAccuracy: Double {
        guard totalQuestions > 0 else { return 0.0 }
        return (Double(correctAnswers) / Double(totalQuestions)) * 100
    }

    // Хранение и возврат количества игр
    var gamesCount: Int {
        get { return storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }

    // Хранение и возврат топ результата игры
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let storedDate = storage.object(forKey: Keys.bestGameDate.rawValue)
            let date: Date = storedDate as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }

    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        totalQuestions += amount
        
        print("Сохраняем игру: \(count) правильных ответов из \(amount)")

        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
        // Проверим, обновляется ли рекорд
        if currentGame.isBetterThan(bestGame) {
            print("Новый рекорд: \(currentGame.correct)/\(currentGame.total) вместо старого рекорда \(bestGame.correct)/\(bestGame.total)")
            bestGame = currentGame
        } else {
            print("Рекорд не побит. Текущий рекорд: \(bestGame.correct)/\(bestGame.total)")
        }
        
        gamesCount += 1
        print("Общее количество игр: \(gamesCount)")
    }
}
