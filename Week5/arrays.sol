pragma solidity 0.8.4;

contract StackClub {
    address[] members;
    bool activeMember;

    constructor() {
        members.push(msg.sender);
    }

    function addMember(address newMember) external {
        if (isMember(newMember) != true) {
            members.push(newMember);
        }
    }

    function isMember(address _address) public view returns (bool _isMember) {
        for (uint i = 0; i < members.length; i++) {
            if (members[i] == _address) {
                _isMember = true;
            }
        }
    }

    function removeLastMember() external {
        if (isMember(msg.sender) == true) {
            members.pop();
        }
    }
}
