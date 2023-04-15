pragma solidity ^0.8.10;

interface ICharacter {
    event Equipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
    event Unequipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
    event Transfer(address indexed _from, address indexed to, uint256 tokenID);
    function equip(uint256 characterID, uint8 slotID, uint256 itemID) external;
    function unequip(uint256 characterID, uint8 slotID, uint256 itemID) external;
}
