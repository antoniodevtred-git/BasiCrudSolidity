# BasicCrud

**BasicCrud** es un smart contract desarrollado en **Solidity 0.8.24** que implementa un sistema de gestión de relojes de lujo con control de roles y CRUD completo.  
Permite registrar, listar, editar y marcar relojes como no disponibles, diferenciando los permisos entre administradores y usuarios normales.

---

## 🧱 Estructura general

### Roles disponibles

| Rol | Valor | Permisos |
|-----|--------|-----------|
| `ADMIN` | 1 | Puede crear, editar, eliminar y ver toda la información (incluyendo precios de compra y beneficios). |
| `NORMAL` | 2 | Solo puede consultar información pública (sin ver precios de compra ni beneficios). |
| `NONE` | 0 | Sin permisos asignados. |

---

## ⚙️ Funcionalidades principales

| Función | Descripción | Permiso |
|----------|--------------|----------|
| `setRole(address user, Role role)` | Asigna un rol a un usuario. | Solo `owner` |
| `registerWatch(string manufacture, string model, string description, uint64 year, uint256 purchase_price, uint256 sell_price)` | Crea un nuevo reloj con sus datos y calcula automáticamente el beneficio. | Solo `ADMIN` |
| `getWatch(uint64 id)` | Muestra la información de un reloj. Los usuarios normales no ven el precio de compra ni el beneficio. | Todos |
| `updateWatch(uint64 id, uint256 newSellPrice, string newDescription)` | Actualiza el precio de venta y descripción (solo si no está vacía). | Solo `ADMIN` |
| `deleteWatch(uint64 id)` | Marca un reloj como no disponible (`available = false`) sin eliminarlo físicamente. | Solo `ADMIN` |
| `listActiveWatches()` | Devuelve un listado de todos los relojes disponibles. | Todos |
| `getActiveWatchesCount()` | Devuelve cuántos relojes siguen disponibles. | Todos |

---

## 🧠 Cálculo de beneficio

El contrato calcula automáticamente el beneficio de cada reloj al registrarlo o al modificar su precio:

```solidity
profit = int256(sell_price) - int256(purchase_price);
Este valor se almacena en la estructura Watch y se actualiza con cada edición.

🧩 Estructura de datos
Watch
Representa un reloj en el sistema.
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
🧾 Eventos
WatchRegistered(uint64 id, string manufacture, string model, uint64 year)	Emite al crear un reloj.
WatchUpdated(uint64 id, uint256 newSellPrice, string newDescription, int256 newProfit)	Emite al actualizar un reloj.
WatchDeleted(uint64 id)	Emite al marcar un reloj como no disponible.

🔒 Modificadores
onlyOwner → Solo el creador del contrato puede ejecutar la función.
onlyAdmin → Solo los usuarios con rol ADMIN pueden ejecutar la función.

🧪 Ejemplo de uso en Remix
Compilación

Abre Remix IDE

Selecciona compilador Solidity 0.8.24

Compila LuxuryWatchesDefi.sol

Despliegue

Ir a Deploy & Run Transactions

Seleccionar entorno Remix VM (London)

Pulsar Deploy

Tu dirección será ADMIN automáticamente.

📊 Estado actual
✅ CRUD completo
✅ Sistema de roles (ADMIN / NORMAL)
✅ Eliminación lógica (available = false)
✅ Listado dinámico de relojes activos
✅ Beneficio calculado automáticamente
✅ Control de permisos por función

---
