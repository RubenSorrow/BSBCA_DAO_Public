// SPDX-License-Identifier: MIT

// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/access/AccessControl.sol";
import "../node_modules/@openzeppelin/contracts/utils/Address.sol";

    /*
    *   Implementation of the AccessControl.sol abastract contract by OpenZeppelin
    *   Determines the roles in the association, their codes and modifiers
    *
    *   Developers are added/removed using AccessControl.sol functions
    *
    *   UPDATES REQUIRED:
    *   - Voting system to elect developers and vote apps
    *
    */

abstract contract Events_AccessManagement is AccessControl { 
	using Address for address;
    using Address for address payable;

    /*
    *   @dev Roles administrated by storage
    *   only one member: 
    *   _roles[role].members.length() = 1
    */
    bytes32 public constant EventsRole = keccak256("Events");
    
    /*
    *   @dev roles administrated by the Head Developer
    *   They are allowed to have multiple memberscan have multiple members
    */
    bytes32 public constant AppRole = keccak256("App");
    bytes32 public constant DeveloperRole = keccak256("Developer");
    
    //admins (single account roles)
    bytes32 public constant EventsAdmin = keccak256("EventsAdmin");
    bytes32 public constant DeveloperAdmin = keccak256("DeveloperAdmin");

    
    //MODIFIERS
    modifier onlyApps() {
        require(_msgSender().isContract(),"access ERROR: The sender is not a contract");
        require(hasRole(AppRole, _msgSender()),"access ERROR: The sender is not a BSBCA App");
        _;
    }
    modifier onlyDevelopers() {
        require(hasRole(DeveloperRole,_msgSender()));
        _;
    }
    


}