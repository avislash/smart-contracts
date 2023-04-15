// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interface/IItem.sol";
import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

enum EquipmentSlot{Head, Chest, LeftHand, RightHand, Feet, CommDevice, Max}
contract Character is ERC721 {
   event Equipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
   event Unequipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
   uint8 private constant MAX_EQUIPMENT_SLOTS = 6; //TODO: Possible to use enum here and keep static decleration for Equipment struct?

   struct Equipment {
       address[MAX_EQUIPMENT_SLOTS] equippedTo;
       uint256[MAX_EQUIPMENT_SLOTS] equipmentID;
   }
   mapping(uint256 => Equipment) internal _equipment;
   mapping (EquipmentSlot => string) internal _slotNames;
   
   uint256 private _tokenID;
   string private _baseTokenURI;  

   constructor(string memory name, string memory symbol, string memory baseTokenURI)
       ERC721(name, symbol) {
          _baseTokenURI = baseTokenURI;
          _slotNames[EquipmentSlot.Head] =  "Head";
          _slotNames[EquipmentSlot.Chest] = "Chest";
          _slotNames[EquipmentSlot.LeftHand] = "Left Hand";
          _slotNames[EquipmentSlot.RightHand] = "Right Hand";
          _slotNames[EquipmentSlot.Feet] = "Feet";
          _slotNames[EquipmentSlot.CommDevice] = "Comm Device";
   }

   function mint() public{
       _mint(msg.sender, _tokenID);
       _tokenID++;
   }

   function _baseURI() internal view override(ERC721) returns (string memory) {
       return _baseTokenURI;
   }


   /**Only allow transfers if no items are unequipped**/
   function transferFrom(address from, address to, uint256 tokenID) public override(ERC721) {
       for (uint8 i = 0; i < MAX_EQUIPMENT_SLOTS; i++) {
           require(true == isSlotEmpty(tokenID, i), "Item Equipped");
       }
       super.transferFrom(from, to, tokenID);
   }

   function safeTransferFrom(address from, address to, uint256 tokenID) public override(ERC721) {
       for (uint8 i = 0; i < MAX_EQUIPMENT_SLOTS; i++) {
           require(true == isSlotEmpty(tokenID, i), "Item Equipped");
       }
       super.safeTransferFrom(from, to, tokenID);
   }

   function safeTransferFrom(address from, address to, uint256 tokenID, bytes memory data) public override(ERC721) {
       for (uint8 i = 0; i < MAX_EQUIPMENT_SLOTS; i++) {
           require(true == isSlotEmpty(tokenID, i), "Item Equipped");
       }
       super.safeTransferFrom(from, to, tokenID, data);
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

   function slotName(uint8 slot) public view returns (string memory) { 
       require(slot < uint8(EquipmentSlot.Max), "Invalid Slot ID");
       return _slotNames[EquipmentSlot(slot)];
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
