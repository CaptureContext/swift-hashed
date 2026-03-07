import Equated

extension Hashed {
	@inlinable
	public init<T>(_: T.Type = T.self)
	where Value == T.Type {
		self.init(
			storedValue: Equated(T.self),
			hasher: .typeID()
		)
	}
}
