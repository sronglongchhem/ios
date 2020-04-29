import Foundation
import Utils
import RxSwift
import RxCocoa

struct DayViewModel: Equatable {
    
    public static func == (lhs: DayViewModel, rhs: DayViewModel) -> Bool {
        return lhs.durationString == rhs.durationString && lhs.dayString == rhs.dayString && lhs.items == rhs.items
    }
    
    let day: Date
    let dayString: String
    let durationString: String
    
    var timeLogCells: [TimeLogCellViewModel]
        
    init(timeLogCells: [TimeLogCellViewModel]) {
        day = timeLogCells.first!.start.ignoreTimeComponents()
        dayString = day.toDayString()
        self.timeLogCells = timeLogCells
        
        durationString = self.timeLogCells
                .filter({ !$0.isInGroup })
                .map({ $0.duration ?? 0 })
                .reduce(0, +)
                .formattedDuration()

    }
}
