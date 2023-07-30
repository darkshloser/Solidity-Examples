// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";


contract FundMe {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    // array of addresses who send ETH to this contract
    address[] public funders;
    //address of the owner (who deployed the contract)
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        // check if the message sender is the owner of the contract
        require(msg.sender == owner);
        _;
    }

    function fund() public payable {
        uint256 minimumUSD = 50 * 10 ** 18;  // $50
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "More ETH is required!"
        );
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e); 
        // address of the contract on Goerli Testnet link: https://docs.chain.link/data-feeds/price-feeds/addresses/?network=ethereum
        priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    function withdraw() payable public onlyOwner {
        // send entire balance to the owner of the contract, when owner call that functionality
        msg.sender.transfer(address(this).balance);

        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }

}