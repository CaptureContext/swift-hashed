import Foundation

extension Hashed.Hasher {
	@inlinable
	public static func uncheckedSendable(
		_ hash: @escaping (Value, inout Swift.Hasher) -> Void
	) -> Self {
		let hash = _UncheckedSendable(action: hash)
		return .custom(hash.callAsFunction)
	}

	@usableFromInline
	struct _UncheckedSendable: @unchecked Sendable {
		private var action: (Value, inout Swift.Hasher) -> Void

		@usableFromInline
		init(action: @escaping (Value, inout Hasher) -> Void) {
			self.action = action
		}

		@usableFromInline
		func callAsFunction(_ value: Value, into hasher: inout Hasher) {
			action(value, &hasher)
		}
	}
}
