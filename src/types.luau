export type InventoryItem = Tool | HopperBin

export type CategoryPredicate = (item: InventoryItem) -> boolean
export type Category = {
	category: string,
	predicate: CategoryPredicate,
}

return nil
