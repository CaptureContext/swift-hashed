import Foundation

extension Hashed.Hasher where Value: AnyObject {
	public static var objectID: Self {
		.property(ObjectIdentifier.init)
	}
}
