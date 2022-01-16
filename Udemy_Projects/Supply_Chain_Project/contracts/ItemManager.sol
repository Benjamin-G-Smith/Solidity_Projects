pragma solidity ^0.6.0;

import "./Item.sol";
import "./Ownable.sol";

contract ItemManager is Ownable{

    // Event? and event type opions??
    enum SupplyChainSteps{Created, Paid, Delivered}

    struct S_Item {
        Item _item;
        ItemManager.SupplyChainSteps _step;
        string _identifier;
    }
    mapping(uint => S_Item) public items;
    uint index;

    event SupplyChainStep(uint _itemIndex, uint _step, address _address);

    function createItem(string memory _identifier, uint _priceInWei) public onlyOwner{
        Item item = new Item(this, _priceInWei, index);
        items[index]._item = item;
        items[index]._identifier = _identifier;
        // Create a new item with Price, id, and event "Created"
        // Store in the mapping as an object of S_Item 
        items[index]._step = SupplyChainSteps.Created;
        // emit the event of Create Item 
        emit SupplyChainStep(index, uint(items[index]._step),address(item));
        index++; // increment the index so the next Item can be added 

    }

    function triggerPayment(uint _index) public payable {
        Item item = items[_index]._item;
        require(address(item) == msg.sender, "Only items are allowed to update themselves");
        require(item.priceInWei() <= msg.value, "Not Fully paid");
        require(items[index]._step == SupplyChainSteps.Created, "Item is further in the supply chain");
        items[_index]._step == SupplyChainSteps.Paid;
        emit SupplyChainStep(index, uint(items[index]._step),address(item));

    }

    function triggerDelivery(uint _index) public onlyOwner {
        require(items[index]._step == SupplyChainSteps.Paid, "Item is further in the supply chain");
        items[_index]._step == SupplyChainSteps.Delivered;
        emit SupplyChainStep(index, uint(items[index]._step),address(items[_index]._item));
    }

}