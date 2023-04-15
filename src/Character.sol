// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interface/IItem.sol";
import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
contract Character is ERC721 {
   //event Transfer(address indexed _from, address indexed to, uint256 tokenID);
   uint256 private _tokenID;
   event Equipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
   event Unequipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
   string private _baseTokenURI;  

   struct Equipment {
       //Equipment Slots:  TODO Define enum
       // 0: head 
       // 1: chest
       // 2: left hand
       // 3: right hand
       // 4: feet
       // 5: comm device
       address[6] equippedTo;
       uint256[6] equipmentID;
   }
   mapping(uint256 => Equipment) internal _equipment;
   

   constructor(string memory name, string memory symbol, string memory baseTokenURI)
       ERC721(name, symbol) {
          _baseTokenURI = baseTokenURI;
   }

   function mint() public{
       _mint(msg.sender, _tokenID);
       _tokenID++;
   }

   function _baseURI() internal view override(ERC721) returns (string memory) {
       return _baseTokenURI;
   }


   function equip(uint256 characterID, uint8 slotID, uint256 itemID) public {
       //Only allow Equipping via Item Contract and original character owner
       require(true == isSlotEmpty(characterID, slotID), "Slot Already Equipped");
       require(false == IItem(msg.sender).isEquipped(itemID), "Item Already Equipped");
       _equipment[characterID].equippedTo[slotID] = msg.sender;
       _equipment[characterID].equipmentID[slotID] = itemID;
       emit Equipped(msg.sender, slotID, itemID);
   }

   function unequip(uint256 characterID, uint8 slotID, uint256 itemID) public {
       //Only alow allow Unequipping via Item Contract
       require(itemID == _equipment[characterID].equipmentID[slotID], "Invalid Item ID");
       require(msg.sender == slotEquippedBy(characterID, slotID), "Invalid Item");
       require(true == IItem(msg.sender).isEquipped(itemID), "Item not equipped");
       _equipment[characterID].equippedTo[slotID] = address(0);
       _equipment[characterID].equipmentID[slotID] = 0;
       emit Unequipped(msg.sender, slotID, itemID);
   }

   function isSlotEmpty(uint256 characterID, uint8 slotID) public view returns (bool) {
       return _equipment[characterID].equippedTo[slotID] == address(0);
   }

   function slotName(uint8 slotID) public pure returns (string memory) { //TODO: This can just be a mapping
       if (slotID == 0) {
           return "HEAD";
       } else if (1 == slotID) {
           return "CHEST";
       } else if (2 == slotID) { 
           return "LEFT HAND";
       } else if (3 == slotID) {
           return "RIGHT HAND";
       } else if (4 == slotID) {
           return "LEGS";
       } else if (5 == slotID) {
           return "COMM";
       }
       revert("INVALID SLOTID");
  }

  function slotEquippedBy(uint256 characterID, uint8 slotID) public view returns (address) {
       require(false == isSlotEmpty(characterID, slotID), "Slot Not Equipped");
       return _equipment[characterID].equippedTo[slotID];
  }

  function slotEquipmentID(uint256 characterID, uint8 slotID) public view returns (uint256) {
       require(false == isSlotEmpty(characterID, slotID), "Slot Not Equipped");
       return _equipment[characterID].equipmentID[slotID];
  }

}
