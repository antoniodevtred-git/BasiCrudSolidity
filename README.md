# 💎 BasicCrud

**BasicCrud** is a smart contract developed in **Solidity 0.8.24** that implements a luxury watch management system with full role control and CRUD functionality.  
It allows registering, listing, editing, and marking watches as unavailable, differentiating permissions between administrators and regular users.

---

## 🧱 General Structure

### Available Roles

| Role | Value | Permissions |
|------|--------|-------------|
| `ADMIN` | 1 | Can create, edit, delete, and view all information (including purchase prices and profits). |
| `NORMAL` | 2 | Can only view public information (purchase prices and profits are hidden). |
| `NONE` | 0 | No assigned permissions. |

---

## ⚙️ Main Functionalities

| Function | Description | Permission |
|-----------|--------------|-------------|
| `setRole(address user, Role role)` | Assigns a role to a user. | Only `owner` |
| `registerWatch(string manufacture, string model, string description, uint64 year, uint256 purchase_price, uint256 sell_price)` | Creates a new watch with its data and automatically calculates profit. | Only `ADMIN` |
| `getWatch(uint64 id)` | Displays the information of a watch. Regular users cannot see purchase price or profit. | Everyone |
| `updateWatch(uint64 id, uint256 newSellPrice, string newDescription)` | Updates the selling price and description (only if not empty). | Only `ADMIN` |
| `deleteWatch(uint64 id)` | Marks a watch as unavailable (`available = false`) without deleting it physically. | Only `ADMIN` |
| `listActiveWatches()` | Returns a list of all available watches. | Everyone |
| `getActiveWatchesCount()` | Returns how many watches are still available. | Everyone |

---

## 🧠 Profit Calculation

The contract automatically calculates the profit of each watch when it is registered or when its selling price is modified:

```solidity
profit = int256(sell_price) - int256(purchase_price);

struct Watch {
    uint64 id;
    string manufacture;
    string model;
    string description;
    uint64 year;
    uint256 purchase_price;
    uint256 sell_price;
    int256 profit;
    bool available;
}

| Event                                                                                    | Description                                    |
| ---------------------------------------------------------------------------------------- | ---------------------------------------------- |
| `WatchRegistered(uint64 id, string manufacture, string model, uint64 year)`              | Emitted when a watch is created.               |
| `WatchUpdated(uint64 id, uint256 newSellPrice, string newDescription, int256 newProfit)` | Emitted when a watch is updated.               |
| `WatchDeleted(uint64 id)`                                                                | Emitted when a watch is marked as unavailable. |


🔒 Modifiers

onlyOwner → Only the contract creator can execute the function.

onlyAdmin → Only users with the ADMIN role can execute the function.

🧪 Example Usage in Remix
Compilation

Open Remix IDE

Select compiler Solidity 0.8.24

Compile LuxuryWatchesDefi.sol

Deployment

Go to Deploy & Run Transactions

Choose environment Remix VM (London)

Click Deploy

Your address will automatically be assigned as ADMIN.

📊 Current Status

✅ Full CRUD functionality
✅ Role-based system (ADMIN / NORMAL)
✅ Logical deletion (available = false)
✅ Dynamic listing of active watches
✅ Automatic profit calculation
✅ Permission control for each function
