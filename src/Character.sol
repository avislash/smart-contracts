// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interface/IItem.sol";
contract Character {
   event Transfer(address indexed _from, address indexed to, uint256 tokenID);
   event Equipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
   event Unequipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
   uint256 _tokenID;
   mapping (uint256 => address)  internal _idToOwner;
   mapping (uint256 => string)  internal _idToTokenURI;
   mapping (address => uint256) internal _balance;

   struct Equipment {
       //Equipment Slots: 
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
   
   string  public name;
   string  public symbol; 
   string  private tokenURIBase;

   constructor(string memory _name, string memory _symbol, string memory _tokenURIBase)  {
       name = _name;
       symbol = _symbol;
       tokenURIBase = _tokenURIBase;
   }

   function mint() public{
       _mint(msg.sender, _tokenID);
       _tokenID++;
   }

   function _mint(address to, uint256 tokenID) private {
       require(to != address(0), "ZERO ADDRESS");
       _idToOwner[tokenID] = to;
       _balance[to]+=1;
       _idToTokenURI[tokenID] = string.concat(tokenURIBase, uint2str(tokenID));
       emit Transfer(address(0), to, tokenID);
   }

   function ownerOf(uint256 tokenID) public view returns (address owner) {
           owner = _idToOwner[tokenID];
           require(owner != address(0), "INVALID NFT");
           return owner;
   }

   function balanceOf(address owner) public view returns (uint256 balance) {
       return _balance[owner];
   }

   function tokenURI(uint256 tokenID) public view returns (string memory) {
           string memory _tokenURI = _idToTokenURI[tokenID];
           require(bytes(_tokenURI).length != 0, "INVALID NFT");
           return _tokenURI;
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

   function slotName(uint8 slotID) public pure returns (string memory) {
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



   function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

}
