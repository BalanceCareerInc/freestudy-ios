import SwiftyJSON

class TagsManager {
    static let sharedInstance = TagsManager()
    var filters: Dictionary<String, Array<String>>!
    var displayNames: Dictionary<String, String>!
    
    init() {
    }
    
    func putTags(tags: JSON) {
        
    }
}