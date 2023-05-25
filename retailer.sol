// Retailer.sol
pragma solidity ^0.8.0;

import "./distributor.sol";

contract Retailer {
    Distributor distributor;
    mapping (uint => uint) public availableItems;

    event ItemAdded(uint itemId, uint availableCount);

    constructor(address distributorAddress) {
        distributor = Distributor(distributorAddress);
    }

    function buyItems(uint id, uint count) payable public returns (bool) {
        require(distributor.availableItems(id) >= count, "Not enough items available");
        require(msg.value == count * 1 ether, "Incorrect amount sent");

        distributor.availableItems(id) -= count;
        availableItems[id] += count;

        emit ItemAdded(id, availableItems[id]);

        return true;
    }
    function sellItems(address customerAddress, uint id, uint count) public {
        require(availableItems[id] >= count, "Not enough items available");
        

        availableItems[id] -= count;
    }

    function getFoodItem(uint id) public view returns (string memory name, uint256 expirationDate, string memory location, uint256 availableCount) {
        return distributor.getFoodItem(id);
    }
}