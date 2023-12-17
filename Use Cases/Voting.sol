// SPDX-License_Identifier: MIT
pragma solidity >=0.4.22 <=0.8.17;

contract Voting {
    mapping(address => uint8) voted;      // (voter  =>  voted)
    mapping(uint8 => uint8) votes;        // (vote   =>  number of votes)
    uint8 maxVotes;
    uint8 winner;

    function getVotes(uint8 number) public view returns (uint8) {
        require(number >= 1 && number <= 5);
        return votes[number];
    }

    function vote(uint8 number) public payable {
        require(number >= 1 && number <= 5 && voted[msg.sender] == 0, "Vote needs vote of range 1 - 5 once!");
        voted[msg.sender] = number;
        votes[number] += 1;
        if (votes[number] >= maxVotes) {
            winner = number;
            maxVotes = votes[number];
        }
    }

    function getCurrentWinner() public view returns (uint8) {
        if (winner == 0) {
            return 1;
        }
        return winner;
    }
}



