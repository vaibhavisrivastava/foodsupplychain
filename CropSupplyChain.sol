// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CropSupplyChain {
    struct Crop {
        uint256 id;
        string name;
        uint256 quantity;
        uint256 lifespan; // in days
        uint256 timestamp;
        address farmer;
        address distributor;
        address wholesaler;
        address shopkeeper;
        address consumer;
    }

    mapping (uint256 => Crop) public crops;

    uint256 public cropCount;

    constructor() {
        cropCount = 0;
    }

    function addCrop(string memory _name, uint256 _quantity, uint256 _lifespan) public returns (uint256) {
        cropCount += 1;
        crops[cropCount] = Crop(cropCount, _name, _quantity, _lifespan, block.timestamp, msg.sender, address(0), address(0), address(0), address(0));
        return cropCount;
    }

    function distributeCrop(uint256 _cropId, address _distributor, address _wholesaler, address _shopkeeper, address _consumer) public {
        require(_distributor != address(0), "Invalid distributor address");
        require(_wholesaler != address(0), "Invalid wholesaler address");
        require(_shopkeeper != address(0), "Invalid shopkeeper address");
        require(_consumer != address(0), "Invalid consumer address");
        Crop storage crop = crops[_cropId];
        require(msg.sender == crop.farmer, "Only the farmer can distribute the crop");
        require(crop.quantity > 0, "Crop quantity is zero");
        crop.distributor = _distributor;
        crop.wholesaler = _wholesaler;
        crop.shopkeeper = _shopkeeper;
        crop.consumer = _consumer;
    }

    function updateCrop(uint256 _cropId, uint256 _quantity, uint256 _lifespan) public {
        Crop storage crop = crops[_cropId];
        require(msg.sender == crop.farmer || msg.sender == crop.distributor || msg.sender == crop.wholesaler || msg.sender == crop.shopkeeper, "Only authorized parties can update the crop");
        crop.quantity = _quantity;
        crop.lifespan = _lifespan;
    }

    function getCrop(uint256 _cropId) public view returns (uint256, string memory, uint256, uint256, uint256, address, address, address, address, address) {
        Crop storage crop = crops[_cropId];
        return (crop.id, crop.name, crop.quantity, crop.lifespan, crop.timestamp, crop.farmer, crop.distributor, crop.wholesaler, crop.shopkeeper, crop.consumer);
    }

    function getFreshness(uint256 _cropId) public view returns (uint256) {
        Crop storage crop = crops[_cropId];
        uint256 elapsed = block.timestamp - crop.timestamp;
        if (elapsed > crop.lifespan) {
            return 0;
        } else {
            return crop.lifespan - elapsed;
        }
    }
}