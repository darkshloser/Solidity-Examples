// SPDX-License_Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract A {
    uint x;

    function setX(uint newX) virtual public {
        x = newX;
    }

    function getX() public virtual view returns (uint) {
        return 1;
    }

}

contract B {
    uint y;

    function setX(uint newY) virtual public {
        y = newY;
    }

    function getX() public virtual view returns (uint) {
        return 2;
    }

}


contract Child is A, B {
    function getX() public override(A,B) view returns (uint) {
        return super.getX();
    }

    function setX(uint newX) public override(A,B) {
        super.setX(newX);
    }

}