pragma solidity 0.8.4;

contract Token {
    uint public totalSupply;
    string public name = "Aleftau";
    string public symbol = "ALF";
    uint8 public decimals = 18;

    mapping(address => uint) balances;

    event Transfer(
        address indexed sender,
        address indexed receiver,
        uint256 tokenAmount
    );

    constructor() {
        totalSupply = 1000 * 10 ** 18;
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(
        address _address
    ) external view returns (uint addrBalance) {
        addrBalance = balances[_address];
    }

    function transfer(
        address recipient,
        uint amount
    ) public returns (bool wasSuccessful) {
        if (balances[msg.sender] < amount) {
            revert("");
        }
        emit Transfer(msg.sender, recipient, amount);
        balances[recipient] += amount;
        balances[msg.sender] -= amount;
        wasSuccessful = true;
    }
}
