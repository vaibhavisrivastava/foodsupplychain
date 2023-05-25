// Customer.sol
pragma solidity ^0.8.0;

import "./retailer.sol";
contract Customer {
    mapping (uint => uint) public purchasedItems;

    event ItemPurchased(uint itemId, uint purchasedCount);

    function buyItems(uint id, uint count) payable public returns (bool) {
        require(Retailer(msg.sender).availableItems(id) >= count, "Not enough items available");
        require(msg.value == count * 1 ether, "Incorrect amount sent");

        Retailer(msg.sender).availableItems(id) -= count;
        purchasedItems[id] += count;

        emit ItemPurchased(id, purchasedItems[id]);

        return true;
    }

    function getPurchasedItem(uint id) public view returns (string memory name, uint256 expirationDate, string memory location, uint256 purchasedCount) {
        (name, expirationDate, location, ) = Retailer(msg.sender).getFoodItem(id);
        purchasedCount = purchasedItems[id];
    }
}