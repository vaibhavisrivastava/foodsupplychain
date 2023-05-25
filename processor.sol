pragma solidity ^0.8.0;

import "./farmer.sol";

contract Processor {
    address public owner;
    Farmer farmer;
    mapping (uint => Farmer.FoodItem) public foodItems;
    mapping (uint => uint) public pricePerUnit;

    event ItemAdded(uint itemId, uint availableCount,uint pricePerUnit);

    constructor(address _farmerAddress) {
        owner = msg.sender;
        farmer = Farmer(_farmerAddress);
    }
    
    function buyItems(uint256 id, uint256 count) public payable {
        
        require(farmer.foodItems(id).availableCount >= count, "Not enough items available");

        (string memory name, uint256 expirationDate, string memory location, uint256 pricePerUnit, uint256 availableCount) = farmer.getFoodItem(id);

        farmer.foodItems(id).availableCount -= count;
        availableCount[id] += count;

        emit ItemAdded(id, availableCount[id]);
      
    }
    
    function sellItems(address distributorAddress, uint id, uint count) public {
        require(availableCount[id] >= count, "Not enough items available");    
        farmer.foodItems(id).availableCount += count;
    }
    
    function getFoodItem(uint256 id) public view returns (string memory name, uint256 expirationDate, string memory location, uint256 pricePerUnit, uint256 availableCount) {
        return farmer.getFoodItem(id);
    }
}


