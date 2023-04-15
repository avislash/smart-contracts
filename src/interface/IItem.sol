pragma solidity ^0.8.10;

interface IItem {
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function approve(address to, uint256 tokenId) external;
    function balanceOf(address owner) external view returns (uint256);
    function equip(address character, uint256 charID, uint256 itemID) external;
    function equippedTo(uint256 itemID) external view returns (address);
    function getApproved(uint256 tokenId) external view returns (address);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function isEquipped(uint256 itemID) external view returns (bool);
    function mint() external;
    function name() external view returns (string memory);
    function ownerOf(uint256 tokenId) external view returns (address);
    function safeTransferFrom(address from, address to, uint256 tokenID) external;
    function safeTransferFrom(address from, address to, uint256 tokenID, bytes memory data) external;
    function setApprovalForAll(address operator, bool approved) external;
    function slotID() external view returns (uint8);
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
    function transferFrom(address from, address to, uint256 tokenID) external;
    function unequip(address character, uint256 charID, uint256 itemID) external;
}
