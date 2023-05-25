pragma solidity ^0.8.4;

contract MultiSig {
    address[] public owners;
    uint256 public required;
    uint256 public _transactionCount;

    struct Transaction {
        address destination;
        uint256 value;
        bool executed;
        bytes data;
    }

    Transaction[] public transactions;
    // mapping(uint=>Transaction) public transactions;

    mapping(uint => mapping(address => bool)) public confirmations;

    constructor(address[] memory _owners, uint256 _required) {
        if (
            _owners.length == 0 || _required == 0 || _required > _owners.length
        ) {
            revert("");
        }
        required = _required;
        owners = _owners;
    }

    function transactionCount() public view returns (uint total) {
        total = transactions.length;
    }

    function addTransaction(
        address _destination,
        uint256 value,
        bytes memory _data
    ) internal returns (uint256 txId) {
        transactions.push(Transaction(_destination, value, false, _data));
        txId = _transactionCount;
        _transactionCount++;
    }

    function getConfirmationsCount(
        uint transactionId
    ) public view returns (uint256 times) {
        for (uint i = 0; i < owners.length; i++) {
            if (confirmations[transactionId][owners[i]] == true) {
                times++;
            }
        }
    }

    function confirmTransaction(uint id) public {
        bool isOwner = false;
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                isOwner = true;
                break;
            }
        }
        if (isOwner == false) {
            revert("");
        }
        confirmations[id][msg.sender] = true;
        if (isConfirmed(id)) {
            executeTransaction(id);
        }
    }

    function submitTransaction(
        address _destination,
        uint256 _value,
        bytes memory _data
    ) external {
        confirmTransaction(addTransaction(_destination, _value, _data));
    }

    receive() external payable {}

    function executeTransaction(uint txId) public {
        if (!isConfirmed(txId)) {
            revert("");
        }

        Transaction memory tx = transactions[txId];

        (bool success, ) = tx.destination.call{value: tx.value}(tx.data);
        require(success, "");

        tx.executed = true;
    }

    function isConfirmed(uint tranId) public view returns (bool confirmed) {
        uint256 count = getConfirmationsCount(tranId);

        confirmed = count == required;
    }
}
