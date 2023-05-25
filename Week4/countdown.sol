pragma solidity ^0.8.4;

contract Contract {
    uint _countdown = 10;

    constructor() payable {}

    function tick() external {
        _countdown--;
        if (_countdown == 0) {
            selfdestruct(payable(msg.sender));
        }
    }
}
