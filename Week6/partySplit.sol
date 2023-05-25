pragma solidity ^0.8.4;

contract Party {
    uint256 amount;
    uint256 pool;
    address[] attendees;

    constructor(uint _amount) {
        amount = _amount;
    }

    function hasRsvp(address _address) public view returns (bool onList) {
        for (uint i = 0; i < attendees.length; i++) {
            if (_address == attendees[i]) {
                onList = true;
            }
        }
    }

    function rsvp() external payable {
        if (msg.value != amount || hasRsvp(msg.sender) == true) {
            revert("");
        }
        pool += msg.value;
        attendees.push(msg.sender);
    }

    function payBill(address venueAddress, uint totalCost) external {
        (bool success, ) = venueAddress.call{value: totalCost}("");
        require(success, "");
        pool -= totalCost;

        for (uint i = 0; i < attendees.length; i++) {
            (bool succ, ) = attendees[i].call{value: pool / attendees.length}(
                ""
            );
            require(succ, "");
        }
        pool = 0;
    }
}
