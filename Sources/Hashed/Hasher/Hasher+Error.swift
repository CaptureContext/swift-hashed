import Foundation

extension Hashed.Hasher where Value: Error {
	@inlinable
	public static var localizedDescription: Self {
		.property(\.localizedDescription)
	}
}
