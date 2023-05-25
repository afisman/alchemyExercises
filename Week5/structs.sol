pragma solidity 0.8.4;

contract Contract {
    enum Choices {
        Yes,
        No
    }

    struct Vote {
        Choices choice;
        address voter;
    }

    // TODO: create a public state variable: an array of votes
    Vote[] public votes;

    function hasVoted(address _address) public view returns (bool voted) {
        for (uint i = 0; i < votes.length; i++) {
            if (_address == votes[i].voter) {
                voted = true;
            }
        }
    }

    function createVote(Choices choice) public {
        if (hasVoted(msg.sender) == true) {
            revert("");
        }
        votes.push(Vote(choice, msg.sender));
    }

    function findChoice(address _address) external view returns (Choices) {
        for (uint i = 0; i < votes.length; i++) {
            if (_address == votes[i].voter) {
                return votes[i].choice;
            }
        }
    }

    function changeVote(Choices choice) external {
        if (hasVoted(msg.sender) == false) {
            revert("");
        }
        for (uint i = 0; i < votes.length; i++) {
            if (msg.sender == votes[i].voter) {
                votes[i].choice = choice;
            }
        }
    }
}
