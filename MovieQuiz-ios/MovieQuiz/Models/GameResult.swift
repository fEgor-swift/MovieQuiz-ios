
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    
    func isBetterThan(_ another: GameResult) -> Bool {
        if self.correct > another.correct {
            return true
        } else if self.correct == another.correct {
            // Если количество правильных ответов одинаково, проверяем дату
            return self.date > another.date
        }
        return false
    }
}

