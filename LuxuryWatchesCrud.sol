// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.24;

contract LuxuryWatchesDefi {
    // --- Variables ---
    address public owner;
    uint64 public totalWatches;

    enum Role { NONE, ADMIN, NORMAL }

    mapping(address => Role) public roles;

    // --- Constructor ---
    constructor() {
        owner = msg.sender;
        roles[owner] = Role.ADMIN;
    }

    // --- Modifiers ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyAdmin() {
        require(roles[msg.sender] == Role.ADMIN, "Only admin can perform this action");
        _;
    }

    // --- Structs ---
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

    mapping(uint64 => Watch) public watches;

    // --- Events ---
    event WatchRegistered(uint64 id, string manufacture, string model, uint64 year);
    event WatchUpdated(uint64 id, uint256 newSellPrice, string newDescription, int256 newProfit);
    event WatchDeleted(uint64 id);

    // --- Functions ---

    // Asignar rol a un usuario (solo el owner puede hacerlo)
    function setRole(address user, Role role) public onlyOwner {
        roles[user] = role;
    }

    // Crear un nuevo reloj (solo admin)
    function registerWatch(
        string memory manufacture,
        string memory model,
        string memory description,
        uint64 year,
        uint256 purchase_price,
        uint256 sell_price
    ) public onlyAdmin {
        int256 profit = int256(sell_price) - int256(purchase_price);

        watches[totalWatches] = Watch({
            id: totalWatches,
            manufacture: manufacture,
            model: model,
            description: description,
            year: year,
            purchase_price: purchase_price,
            sell_price: sell_price,
            profit: profit,
            available: true
        });

        emit WatchRegistered(totalWatches, manufacture, model, year);
        totalWatches++;
    }

    // Actualizar reloj (solo admin)
    function updateWatch(
        uint64 id,
        uint256 newSellPrice,
        string memory newDescription
    ) public onlyAdmin {
        require(id < totalWatches, "Watch not found");
        Watch storage w = watches[id];

        // Actualiza el precio y recalcula el beneficio
        w.sell_price = newSellPrice;
        w.profit = int256(newSellPrice) - int256(w.purchase_price);

        // Actualiza descripción solo si se pasa un texto nuevo
        if (bytes(newDescription).length != 0) {
            w.description = newDescription;
        }

        emit WatchUpdated(id, newSellPrice, w.description, w.profit);
    }

    // Eliminar reloj (solo admin)
function deleteWatch(uint64 id) public onlyAdmin {
    require(id < totalWatches, "Watch not found");
    require(watches[id].available == true, "Watch already inactive");

    watches[id].available = false;
    emit WatchDeleted(id);
}


    // Leer reloj por ID
    function getWatch(uint64 id) public view returns (
        uint64,
        string memory,
        string memory,
        string memory,
        uint64,
        uint256,
        uint256,
        int256,
        bool
    ) {
        Watch memory w = watches[id];
        if (roles[msg.sender] != Role.ADMIN) {
            // Si no eres admin, ocultamos información sensible
            return (
                w.id,
                w.manufacture,
                w.model,
                w.description,
                w.year,
                0,              // purchase_price oculto
                w.sell_price,   // visible
                0,              // profit oculto
                w.available
            );
        } else {
            return (
                w.id,
                w.manufacture,
                w.model,
                w.description,
                w.year,
                w.purchase_price,
                w.sell_price,
                w.profit,
                w.available
            );
        }
    }
}
