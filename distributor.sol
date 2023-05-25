// Distributor.sol
pragma solidity ^0.8.0;

import "./processor.sol";

contract Distributor {
    Processor processor;
    mapping (uint => uint) public availableItems;

    event ItemAdded(uint itemId, uint availableCount);

    constructor(address processorAddress) {
        processor = Processor(processorAddress);
    }

    function buyItems(uint id, uint count) public {
        require(processor.availableItems(id) >= count, "Not enough items available");
        require(availableItems[id] + count <= 100, "Cannot exceed 100 items per transaction");

        processor.foodItems(id).availableCount -= count;
        availableItems[id] += count;

        emit ItemAdded(id, availableItems[id]);
    }

    function sellItems(address retailerAddress, uint id, uint count) public {
        require(availableItems[id] >= count, "Not enough items available");
        
        availableItems[id] -= count;
    }

    function getFoodItem(uint id) public view returns (string memory name, uint256 expirationDate, string memory location, uint256 availableCount) {
        return processor.getFoodItem(id);
    }
}

