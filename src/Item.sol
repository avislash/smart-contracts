// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./interface/ICharacter.sol";
import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
contract Item is ERC721{
   uint256 private _tokenID;
   uint8 private _slotID;
   string private _baseTokenURI;
   mapping (uint256 => address) internal _itemEquippedTo;

   constructor(string memory name, string memory symbol, string memory baseTokenURI, uint8 charSlotID) ERC721(name, symbol) {
       _baseTokenURI = baseTokenURI;
       _slotID = charSlotID;
   }

   function mint() public{
       _mint(msg.sender, _tokenID);
       _tokenID++;
   }

   function _baseURI() internal view override(ERC721) returns (string memory) {
       return _baseTokenURI;
   }

   /**Only allow transfers if item is not equipped**/
   function transferFrom(address from, address to, uint256 tokenID) public override(ERC721) {
       require(false == isEquipped(tokenID), "Item Equipped");
       super.transferFrom(from, to, tokenID);
   }

   function safeTransferFrom(address from, address to, uint256 tokenID) public override(ERC721) {
       require(false == isEquipped(tokenID), "Item Equipped");
       super.safeTransferFrom(from, to, tokenID);
   }

   function safeTransferFrom(address from, address to, uint256 tokenID, bytes memory data) public override(ERC721) {
       require(false == isEquipped(tokenID), "Item Equipped");
       super.safeTransferFrom(from, to, tokenID, data);
   }

   function equip(address character, uint256 charID, uint256 itemID) public {
           require(msg.sender == _ownerOf(itemID), "Invalid owner");
           require(false == isEquipped(itemID), "Already equipped");
           ICharacter(character).equip(charID, _slotID, itemID);
           _itemEquippedTo[itemID] = character;
   }

   function unequip(address character, uint256 charID, uint256 itemID) public {
           require(msg.sender == _ownerOf(itemID), "Invalid owner");
           ICharacter(character).unequip(charID, _slotID, itemID);
           _itemEquippedTo[itemID] = address(0);
   }

   function isEquipped(uint256 itemID) public view returns (bool) {
       return _itemEquippedTo[itemID] != address(0);
   }

   function equippedTo(uint256 itemID) public view returns (address) {
      require(true == isEquipped(itemID), "Not Equipped");
      return _itemEquippedTo[itemID];
   }

   function slotID() public view returns (uint8) {
       return _slotID;
   }
}
