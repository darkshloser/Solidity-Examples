pragma solidity >=0.7.0 <0.9.0;


contract TimedAuction {
    // Declare your event(s) here
    event Bid(address indexed sender, uint256 amount, uint256 timestamp);

    address owner;
    uint256 highestBid;
    address highestBidAddress;
    uint256 timeOfDeploy;
    mapping(address => uint256) userBids;
    mapping(address => bool) alreadyBided;
    uint256 totalBids;


    modifier onlyOwner {
        require(owner == msg.sender, "Only owner can call this finctionality");
        _;
    }

    modifier isAuctionOpen {
        require(block.timestamp - timeOfDeploy < 5 minutes, "Auction is closed");
        _;
    }

    modifier validBid {
        require(msg.value > highestBid, "Bid is not large enough");
        _;
    }

    modifier isBidder {
        require(alreadyBided[msg.sender] == true, "You're not participant in the bidding");
        _;
    }


    constructor() {
        owner = msg.sender;
        timeOfDeploy = block.timestamp;
    }

    function bid() external payable isAuctionOpen validBid {
        highestBid = msg.value;
        highestBidAddress = msg.sender;
        userBids[msg.sender] += msg.value;
        totalBids += msg.value;
        alreadyBided[msg.sender] = true;
        emit Bid(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public isBidder {
        uint256 valueToSend;
        if (highestBidAddress == msg.sender) {
            require(highestBid < userBids[msg.sender], "No previouse bids to withdraw");
            valueToSend = userBids[msg.sender] - highestBid;
        } else {
            valueToSend = userBids[msg.sender];
        }
        totalBids -= valueToSend;
        userBids[msg.sender] -= valueToSend;
        (bool sent,) = payable(msg.sender).call{value: valueToSend}("");
        require(sent, "Withdraw failed");
    }

    function claim() public onlyOwner {
        require(block.timestamp - timeOfDeploy >= 5 minutes);
        require(totalBids == highestBid, "All bidders needs to withdraw first");
        selfdestruct(payable(owner));
    }

    function getHighestBidder() public view returns (address) {
        return highestBidAddress;
    }
}

