// SPDX-License_Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Item {
    string name;
    uint price;

    constructor(string memory _name, uint _price) {
        name = _name;
        price = _price;
    }
    
    function getName() public view returns(string memory) {
        return name;
    }

    function getPrice() public virtual view returns(uint256) {
        return price;
    }
}


contract TaxedItem is Item {
    uint256 tax;

    constructor(string memory name, uint256 price, uint256 _tax) Item(name, price) {
        tax = _tax;
    }

    function getPrice() public override view returns(uint256) {
        return price + tax;
    }

}
