pragma solidity 0.8.4;

contract Escrow {
    address public depositor;
    address public beneficiary;
    address public arbiter;
    bool public isApproved;
    bool public isDeposited;
    uint balance;

    event Approved(uint _balance);

    constructor(address _arbiter, address _beneficiary) payable {
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;

        balance = msg.value;
        isDeposited = true;
    }

    function approve() external payable {
        if (msg.sender != arbiter) {
            revert("");
        }
        (bool sent, ) = beneficiary.call{value: balance}("");
        require(sent, "Failed to send");
        isApproved = true;
        emit Approved(balance);
    }
}
