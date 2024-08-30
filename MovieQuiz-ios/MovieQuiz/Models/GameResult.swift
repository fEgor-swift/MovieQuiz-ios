
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    func isBetterThan(_ another: GameResult) -> Bool {
        if self.correct > another.correct {
            return true
        } else if self.correct == another.correct {
            
            return self.date > another.date
        }
        return false
    }
}

