import Foundation

extension Hashed.Hasher where Value: AnyObject {
	public static var objectID: Self {
		.uncheckedSendable(ObjectIdentifier.init)
	}
}
