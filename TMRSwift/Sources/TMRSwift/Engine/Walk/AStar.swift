import Foundation
import SwiftGodot

extension Vector2 : Hashable {
    public func hash(into hasher: inout Hasher) {
      hasher.combine(x)
      hasher.combine(y)
    }
}

struct AStar {
    
    struct Graph {
        let points:[Vector2]
        let conections:[(Vector2, Vector2)]
        
        func neighbours(_ point:Vector2) -> [Vector2]{
            conections
                .filter  { $0.near(point, treshold: 0.1) || $1.near(point, treshold:0.1) }
                .flatMap { [$0, $1] }
                .filter  { $0 != point}
        }
        
        func cost(from:Vector2, to:Vector2) -> Double {
            //Double(sqrt(pow((from.x - to.x), 2) + pow((from.y - to.y), 2)))
            Double(abs(from.x - to.x) + abs(from.y - to.y))
        }
        
        func heuristic(from:Vector2, to:Vector2) -> Double {
            //Double(sqrt(pow((from.x - to.x), 2) + pow((from.y - to.y), 2)))
            Double(abs(from.x - to.x) + abs(from.y - to.y))
        }
    }
    
    struct Score {
        var f:Double
        var g:Double
        var h:Double
        
        init(point:Vector2, goal:Vector2){
            f = 0
            g = 0
            h = 0
        }
    }
    
    
    let graph:Graph
    let start:Vector2
    let goal:Vector2
    
    
    //https://gist.github.com/damienstanton/7de65065bf584a43f96a
    func findPath() -> [Vector2]? {
        var openList  :[Vector2] = [start]           // The set of tentative nodes to be evaluated
        var closedList:[Vector2] = []                // The set of nodes already evaluated.
        
        var cameFrom:[Vector2:Vector2] = [:]         // The map of navigated nodes.
        var g_scores:[Vector2:Double]  = [start : 0] // Cost from start along best known path.
        
        // Estimated total cost from start to goal through y.
        var f_scores:[Vector2:Double] = [start: g_scores[start]! + graph.heuristic(from:start, to: goal)]
                        
        while openList.count > 0 {
            let current = lowest(openList, f_scores)
            if current == goal {
                return reconstructPath(cameFrom:cameFrom, current:goal)
            }
            
            openList.remove(at: openList.firstIndex(of: current)!)
            closedList.append(current)
            
            for successor in graph.neighbours(current) {
                
                if closedList.contains(successor){
                    continue
                }
                
                let tentative_g_scores = g_scores[current]! + graph.cost(from: current, to: successor)
                
                if !openList.contains(successor) || tentative_g_scores < g_scores[successor]! {
                    cameFrom[successor] = current
                    g_scores[successor] = tentative_g_scores
                    f_scores[successor] = g_scores[successor]! + graph.heuristic(from: successor, to: goal)
                    if !openList.contains(successor){
                        openList.append(successor)
                    }
                }
            }
        }
        
        return nil
    }

    
    func reconstructPath(cameFrom:[Vector2:Vector2], current:Vector2) -> [Vector2]{
        var current = current
        var path:[Vector2] = [current]
        while cameFrom[current] != nil {
            current = cameFrom[current]!
            path.append(current)
        }
        return path.reversed()
    }
    
    func lowest(_ list:[Vector2], _ fScores:[Vector2:Double]) -> Vector2{
        list.min { left, right -> Bool in
            fScores[left]! < fScores[right]!
        }!
    }
    
}
