pragma solidity ^0.8.10;

interface IItem{
    function isEquipped(uint256 itemID) external returns (bool);
}
