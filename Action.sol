pragma solidity >=0.7.0 <0.9.0;


contract Auction {
    address owner;
    uint highestBid;
    address highestBidder;
    mapping(address => uint) oldBids;

    event Bid(address indexed bidder, uint indexed value); 
    event StopAuction(address highestBidder, uint highestBid);
    // indexed enable searching by specific field in Bid events
    // max 3 'indexed' fields per event
    // evelything that is indexed is known as a tipic and not indexed as data

    constructor() {
        owner = msg.sender;
    }

    function bid() external payable {
        require(msg.value >= highestBid);
        require(owner != msg.sender);
        oldBids[highestBidder] = highestBid;
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        require(msg.sender != owner, "Owner can not withdraw from the contract");
        uint value = oldBids[msg.sender];
        oldBids[msg.sender] = 0;
        (bool sent,) = payable(msg.sender).call{value: value}("");
        require(sent, "Payment failed");
    }

    function stopAuction() external {
        require(msg.sender == owner);
        emit StopAuction(highestBidder, highestBid);
        selfdestruct(payable(owner));
    }
}