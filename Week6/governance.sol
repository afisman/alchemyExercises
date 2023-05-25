pragma solidity ^0.8.4;

contract Voting {
    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
    }

    Proposal[] public proposals;

    address[] private members;

    mapping(uint => bool) public proposalIdToVoteStatus;

    event ProposalCreated(uint proposalId);

    event VoteCast(uint proposalId, address voterAddress);

    constructor(address[] memory _members) {
        members = _members;
        members.push(msg.sender);
    }

    function newProposal(address _target, bytes calldata _data) external {
        bool isMember = false;
        for (uint i = 0; i < members.length; i++) {
            if (msg.sender == members[i]) {
                isMember = true;
            }
        }

        if (isMember == false) {
            revert("Only members can create proposals");
        }
        proposals.push(Proposal(_target, _data, 0, 0));
        emit ProposalCreated(proposals.length - 1);
    }

    function castVote(uint proposalId, bool vote) external {
        bool isMember = false;
        for (uint i = 0; i < members.length; i++) {
            if (msg.sender == members[i]) {
                isMember = true;
            }
        }
        if (isMember == false) {
            revert("Only members can vote");
        }
        Proposal storage proposal = proposals[proposalId];
        emit VoteCast(proposalId, msg.sender);

        // * check whether user cast the vote before?
        if (proposalIdToVoteStatus[proposalId]) {
            // * true means casted.

            if (vote) {
                proposal.yesCount++;
                if (proposal.noCount > 0) {
                    proposal.noCount--;
                }
            } else {
                proposal.noCount++;
                if (proposal.yesCount > 0) {
                    proposal.yesCount--;
                }
            }
        } else {
            // * false means not casted.

            if (vote) {
                proposal.yesCount++;
            } else {
                proposal.noCount++;
            }

            proposalIdToVoteStatus[proposalId] = true;
        }

        if (proposal.yesCount == 10) {
            (bool success, ) = proposal.target.call(proposal.data);
            require(success, "");
        }
    }
}
