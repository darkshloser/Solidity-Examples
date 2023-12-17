pragma solidity >=0.7.0 <0.9.0;


library Math {
// Rules:
// - Stateless
// - Library can not be derstoied (self.destroy)
// - Library can not inherit from another library
// - Library can be inherited (I can't have chiled contract of library)
// - all of the functions in library must have an implementation (I can not have abstract function in library)

// you can define struct and enum

    function max(int[] memory numbers) public pure returns (int) {
        if (numbers.length == 0) {
            return 0;
        }
        int currentMax = numbers[0];
        for (uint idx; idx < numbers.length; idx++) {
            if (numbers[idx] > currentMax) {
                currentMax = numbers[idx];
            }
        }
        return currentMax;
    }

    function max(uint[] memory numbers) public pure returns (uint) {
        if (numbers.length == 0) {
            return 0;
        }
        uint currentMax = numbers[0];
        for (uint idx; idx < numbers.length; idx++) {
            if (numbers[idx] > currentMax) {
                currentMax = numbers[idx];
            }
        }
        return currentMax;
    }

}


contract Test {
    using Math for int[];
    using Math for uint[];

    int[] numbers;
    uint[] uNumbers;

    function addNumber(int number) public {
        numbers.push(number);
    }

    function addUNumber(uint uNumber) public {
        uNumbers.push(uNumber);
    }

    function getMax() public view returns (int, uint) {
        return (numbers.max(), uNumbers.max());
    } 

}



