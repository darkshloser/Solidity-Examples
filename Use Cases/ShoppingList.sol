pragma solidity >=0.7.0 <0.9.0;



contract ShoppingList {
    // Write your structs here

    struct Item {
        string name;
        uint quantity;
    }
    struct List {
        string name;
        Item[] items;
    }
    mapping(address => mapping(string => List)) shopList;
    mapping(address => string[]) listNames;

    function checkListEmpty(string memory name) internal view returns (bool) {
        return bytes(shopList[msg.sender][name].name).length == 0;
    }

    function createList(string memory name) public {
        require(checkListEmpty(name) == true, "List is not empty");
        require(bytes(name).length != 0, "Name can not be empty");
        shopList[msg.sender][name].name = name;
        listNames[msg.sender].push(name);
    }

    function getListNames() public view returns (string[] memory) {
        require(listNames[msg.sender].length > 0, "There is no shopping lists");
        return listNames[msg.sender];
    }

    function getItemNames(string memory listName)
        public
        view
        returns (string[] memory)
    {
        require(checkListEmpty(listName) == false, "List is empty");
        string[] memory itemNames = new string[](shopList[msg.sender][listName].items.length);
        for (uint i; i < itemNames.length; i++) {
            itemNames[i] = shopList[msg.sender][listName].items[i].name;
        }
        return itemNames;
    }

    function addItem(
        string memory listName,
        string memory itemName,
        uint256 quantity
    ) public {
        require(checkListEmpty(listName) == false, "List is empty");
        shopList[msg.sender][listName].items.push(Item(itemName, quantity));
    }
}

