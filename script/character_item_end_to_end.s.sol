// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/Character.sol";
import "../src/Item.sol";

contract CharacterScript is Script {
   function run() public {
       vm.startBroadcast(vm.envUint("FORGE_ANVIL_PRIVATE_KEY"));
       uint8 commSlot = uint8(EquipmentSlot.CommDevice);
       Character character = Character(vm.envAddress("CHARACTER_CONTRACT_ADDRESS"));
       Item comm = Item(vm.envAddress("ITEM_CONTRACT_ADDRESS"));
       
       uint256 balance = character.balanceOf(vm.envAddress("FORGE_ANVIL_PUBLIC_KEY"));
       console.log("Character Name: %s", character.name());
       console.log("Character Symbol: %s", character.symbol());
       console.log("Character Balance Of %s: %d", vm.envAddress("FORGE_ANVIL_PUBLIC_KEY"), balance);
       if (balance < 1) {
           character.mint();
           console.log("Balance Of Character Post Mint %s: %d", vm.envAddress("FORGE_ANVIL_PUBLIC_KEY"), character.balanceOf(vm.envAddress("FORGE_ANVIL_PUBLIC_KEY")));
       }


       console.log("Owner of Character Token 0: %s", character.ownerOf(0)); 
       console.log("Character Token URI: %s", character.tokenURI(0));

       balance = comm.balanceOf(vm.envAddress("FORGE_ANVIL_PUBLIC_KEY"));
       console.log("Item Name: %s", comm.name());
       console.log("Item Symbol: %s", comm.symbol());
       console.log("Item Balance Of %s: %d", vm.envAddress("FORGE_ANVIL_PUBLIC_KEY"), balance);
       if (balance < 1) {
           comm.mint();
           console.log("Balance Of Item Post Mint %s: %d", vm.envAddress("FORGE_ANVIL_PUBLIC_KEY"), comm.balanceOf(vm.envAddress("FORGE_ANVIL_PUBLIC_KEY")));
       }

       console.log("Checking slot");

       bool slotAvail = character.isSlotEmpty(0, commSlot);
       console.log("Slot Empty: ", slotAvail);
       
       if (true == slotAvail) {
            console.log("Equipping %s", comm.name());
            comm.equip(vm.envAddress("CHARACTER_CONTRACT_ADDRESS"), 0, 0);
       } else {
           console.log("Unequipping %s", comm.name());
           comm.unequip(vm.envAddress("CHARACTER_CONTRACT_ADDRESS"), 0, 0);
       }

       printEquipmentInfo(character, comm);


       vm.stopBroadcast();
   }

   function printEquipmentInfo(Character character, Item item) public view {
       uint8 commSlot = uint8(EquipmentSlot.CommDevice);
       bool slotAvail = character.isSlotEmpty(0,commSlot);
       console.log("Slot 5 (%s) Empty: %s", character.slotName(commSlot), slotAvail);
       if (slotAvail) {
           return;
       }
       console.log("%s equipped to: ", item.name(), item.equippedTo(0));
       console.log("Character %s slot equipped by: %s", character.slotName(commSlot), character.slotEquippedBy(0, commSlot)); 
   }
}
