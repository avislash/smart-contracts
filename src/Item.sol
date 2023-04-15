// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./interface/ICharacter.sol";
contract Item {
   event Transfer(address indexed _from, address indexed to, uint256 tokenID);
   string  public name;
   string  public symbol; 
   string  private tokenURIBase;
   uint8   private _slotID;
   uint256 _tokenID;
   mapping (uint256 => address) internal _idToOwner;
   mapping (uint256 => string)  internal _idToTokenURI;
   mapping (address => uint256) internal _balance;
   mapping (uint256 => address) internal _itemEquippedTo;

   constructor(string memory _name, string memory _symbol, string memory _tokenURIBase, uint8 slotID)  {
       name = _name;
       symbol = _symbol;
       tokenURIBase = _tokenURIBase;
       _slotID = slotID;
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

   function equip(address character, uint256 charID, uint256 itemID) public {
           require(msg.sender == _idToOwner[itemID], "Invalid owner");
           require(false == isEquipped(itemID), "Already equipped");
           ICharacter(character).equip(charID, _slotID, itemID);
           _itemEquippedTo[itemID] = character;
   }

   function unequip(address character, uint256 charID, uint256 itemID) public {
           require(msg.sender == _idToOwner[itemID], "Invalid owner");
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
