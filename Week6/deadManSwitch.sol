pragma solidity 0.8.4;

contract Switch {
    address owner;
    address recipient;
    uint amount;
    uint lastPing = block.timestamp;

    constructor(address _address) payable {
        recipient = _address;
        owner = msg.sender;
        amount = msg.value;
    }

    function withdraw() external {
        if ((block.timestamp - lastPing) / (60 * 60 * 24 * 7) < 52) {
            revert("Not enough time");
        }
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "");
    }

    function ping() external {
        if (msg.sender != owner) {
            revert("");
        }
        lastPing = block.timestamp;
    }
}
