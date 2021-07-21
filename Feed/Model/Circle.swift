//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  Circle.swift
//  Feed
//
//  Created by Tanakorn Phoochaliaw on 21/7/2564 BE.
//

import SwiftyJSON

// MARK: - Circle
public enum CircleKey: String, Codable {
    case id
    case slug
    case name
    case key
}

public class Circle: NSObject {
    let id: String
    let slug: String
    let name: String
    let key: String
    
    init(json: JSON) {
        self.id = json[CircleKey.id.rawValue].stringValue
        self.slug = json[CircleKey.slug.rawValue].stringValue
        self.name = json[CircleKey.name.rawValue].stringValue
        self.key = json[CircleKey.key.rawValue].stringValue
    }
}
