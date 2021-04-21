// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./Membership_Storage.sol";

contract addApp is Context {

	Membership_Storage stor;

	constructor(address addr){
		stor = Membership_Storage(addr);
	}

	modifier onlyDevelopers() {
		require(stor.hasRole(keccak256("Developer"),_msgSender()),"app Error: The sender is not a developer");
		_;
	}

	function newMember(uint32 id,address addr) public onlyDevelopers() {
		stor.addMember(id,addr);
	}
}