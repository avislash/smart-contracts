pragma solidity ^0.8.10;

interface ICharacter {
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Equipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Unequipped(address indexed _item, uint256 indexed slotID, uint256 indexed itemID);

    function approve(address to, uint256 tokenId) external;
    function balanceOf(address owner) external view returns (uint256);
    function equip(uint256 characterID, uint8 slotID, uint256 itemID) external;
    function getApproved(uint256 tokenId) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function isSlotEmpty(uint256 characterID, uint8 slotID) external view returns (bool);
    function mint() external;
    function name() external view returns (string memory);
    function ownerOf(uint256 tokenId) external view returns (address);
    function safeTransferFrom(address from, address to, uint256 tokenID) external;
    function safeTransferFrom(address from, address to, uint256 tokenID, bytes memory data) external;
    function setApprovalForAll(address operator, bool approved) external;
    function slotEquipmentID(uint256 characterID, uint8 slotID) external view returns (uint256);
    function slotEquippedBy(uint256 characterID, uint8 slotID) external view returns (address);
    function slotName(uint8 slotID) external pure returns (string memory);
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
    function transferFrom(address from, address to, uint256 tokenID) external;
    function unequip(uint256 characterID, uint8 slotID, uint256 itemID) external;
}
