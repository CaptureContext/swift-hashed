import Foundation

extension Hashed {
	public struct Hasher: Sendable {
		@usableFromInline
		internal let hash: @Sendable (Value, inout Swift.Hasher) -> Void

		@usableFromInline
		internal init(hash: @escaping @Sendable (Value, inout Swift.Hasher) -> Void) {
			self.hash = hash
		}

		@inlinable
		public func hash(_ value: Value, into hasher: inout Swift.Hasher) -> Void {
			hash(value, &hasher)
		}

		@inlinable
		public func hashValue(for value: Value) -> Int {
			var hasher = Swift.Hasher()
			self.hash(value, into: &hasher)
			return hasher.finalize()
		}
	}
}

extension Hashed.Hasher {
	@inlinable
	public static var empty: Self {
		.uncheckedSendable { _, _ in }
	}

	@inlinable
	public static func custom(
		_ hash: @escaping @Sendable (Value, inout Swift.Hasher) -> Void
	) -> Self {
		return .init(hash: hash)
	}

	public static var uncheckedSendableDump: Self {
		.uncheckedSendable { value, hasher in
			var valueDump = ""
			Swift.dump(value, to: &valueDump)
			valueDump.hash(into: &hasher)
		}
	}
}

extension Hashed.Hasher where Value: Sendable {
	public static var dump: Self {
		.custom { value, hasher in
			var valueDump = ""
			Swift.dump(value, to: &valueDump)
			valueDump.hash(into: &hasher)
		}
	}
}
