pragma solidity ^0.8.0;
contract Farmer {
    struct FoodItem {
        string name;
        uint256 expirationDate;
        string location;
        uint256 pricePerUnit;
        uint256 availableCount;
    }

    mapping(uint256 => FoodItem) public foodItems;
    uint256 public foodItemCount;
    

    event FoodItemAdded(uint256 id, string name, uint256 expirationDate, string location, uint256 pricePerUnit, uint256 availableCount);

    function addFoodItem(string memory name, uint256 expirationDate, string memory location, uint256 pricePerUnit, uint256 availableCount) public {
        foodItemCount++;
        foodItems[foodItemCount] = FoodItem(name, expirationDate, location, pricePerUnit, availableCount);
        emit FoodItemAdded(foodItemCount, name, expirationDate, location, pricePerUnit, availableCount);
    }

    function getFoodItem(uint256 id) public view returns (string memory name, uint256 expirationDate, string memory location, uint256 pricePerUnit, uint256 availableCount) {
        require(id <= foodItemCount, "Invalid food item id");
        FoodItem storage item = foodItems[id];
        return (item.name, item.expirationDate, item.location, item.pricePerUnit, item.availableCount);
    }
    function updateFoodItem(uint256 id, uint256 availableCount) public {
        require(id <= foodItemCount, "Invalid food item id");
        require(foodItems[id].availableCount >= availableCount, "Cannot set available count more than total count");
        foodItems[id].availableCount = availableCount;
    }
}
