pragma solidity ^0.8.4;

contract Collectible {
    address owner;
    bool forSale;
    uint collectiblePrice;

    event Deployed(address indexed owner);

    event Transfer(address indexed owner, address indexed newOwner);

    event ForSale(uint price, uint currBlockTimestamp);

    event Purchase(uint purchaseAmount, address indexed buyer);

    constructor() {
        emit Deployed(msg.sender);
        owner = msg.sender;
    }

    function transfer(address _address) external {
        emit Transfer(owner, _address);
        if (owner != msg.sender) {
            revert("");
        }
        owner = _address;
    }

    function markPrice(uint askingPrice) external {
        emit ForSale(askingPrice, block.timestamp);
        if (owner != msg.sender) {
            revert("");
        }
        collectiblePrice = askingPrice;
        forSale = true;
    }

    function purchase() external payable {
        (bool success, ) = owner.call{value: msg.value}("");
        require(success);
        emit Transfer(owner, msg.sender);
        emit Purchase(msg.value, msg.sender);

        if (collectiblePrice != msg.value || forSale == false) {
            revert("");
        }
        owner = msg.sender;
        forSale = false;
    }
}
