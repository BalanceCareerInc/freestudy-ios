import SwiftyJSON

class TagsManager {
    static let sharedInstance = TagsManager()
    var filters: Dictionary<String, Array<String>>!
    var displayNames: Dictionary<String, String>!
    var categories: Array<String>!
    var areas: Array<String>!
    
    init() {
    }
    
    func nameOf(tagValue: String) -> String {
        if (self.displayNames[tagValue] != nil) {
            return self.displayNames[tagValue]!
        }
        else {
            return "기타"
        }
    }
    
    func putTags(tags: JSON) {
        self.displayNames = Dictionary(map(tags["display_names"].dictionaryValue){
            (key, value) in (key, value.stringValue)
        })
        self.filters = Dictionary(map(tags["filters"].dictionaryValue){
            (key:String, value:JSON) in
            (key, map(value.arrayValue){(tagName:JSON) -> String in tagName.stringValue})
        })
        
        self.categories = extractEndNodes(filters["category"]!)
        self.areas = extractEndNodes(filters["area"]!)
    }
    
    func extractEndNodes(children: Array<String>, depth: Int = 0) -> Array<String> {
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