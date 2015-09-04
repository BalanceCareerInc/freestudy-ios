import SwiftyJSON

class TagsManager {
    static let sharedInstance = TagsManager()
    private var filters: Dictionary<String, Array<String>>!
    private var displayNames: Dictionary<String, String>!
    private var parents = Dictionary<String, String>()
    var categories: Array<String>!
    var areas: Array<String>!
    
    private init() {
    }
    
    func parentOf(tagValue: String) -> String? {
        return self.parents[tagValue]
    }
    
    func nameOf(tagValue: String) -> String {
        if (self.displayNames[tagValue] != nil) {
            return self.displayNames[tagValue]!
        }
        else {
            return "기타"
        }
    }
    
    func isSubSubTag(tagValue: String) -> Bool {
        var current:String? = tagValue
        for i in 0...2 {
            current = self.parents[current!]
            if current == nil {
                return false
            }
        }
        return true
    }
    
    func putTags(tags: JSON) {
        self.displayNames = Dictionary(map(tags["display_names"].dictionaryValue){
            (key, value) in (key, value.stringValue)
        })
        self.filters = Dictionary(map(tags["filters"].dictionaryValue){
            (key:String, value:JSON) in
            (key, map(value.arrayValue){(tagName:JSON) -> String in tagName.stringValue})
        })
        
        for parent in self.filters.keys {
            for child in self.filters[parent]! {
                self.parents[child] = parent
            }
        }
        
        self.categories = extractEndNodes(filters["category"]!)
        self.areas = extractEndNodes(filters["area"]!)
    }
    
    private func extractEndNodes(children: Array<String>, depth: Int = 0) -> Array<String> {
        var endNodes = Array<String>()
        for child in children {
            if(filters[child] != nil && depth == 0) {
                endNodes.extend(extractEndNodes(filters[child]!, depth: depth + 1))
            }
            else {
                endNodes.append(child)
            }
        }
        return endNodes
    }
}