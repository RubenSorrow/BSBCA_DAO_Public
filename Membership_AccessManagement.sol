// SPDX-License-Identifier: MIT


pragma solidity >=0.6.2 <0.8.0;

import "../AccessControl.sol";

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

abstract contract Membership_AccessManagement is AccessControl {
    using Address for address;
    using Address for address payable;
    
    /*
    *   @dev Roles administrated by storage
    *   only one member: 
    *   _roles[role].members.length() = 1
    */
    bytes32 public constant PresidentRole = keccak256("President");
    bytes32 public constant CommunicationsRole = keccak256("Communications");
    bytes32 public constant DataRole = keccak256("Data");
    
    /*
    *   @dev roles administrated by the Head Developer
    *   They are allowed to have multiple memberscan have multiple members
    */
    bytes32 public constant AppRole = keccak256("App");
    bytes32 public constant DeveloperRole = keccak256("Developer");
    
    //admins (single account roles)
    bytes32 public constant DeveloperAdmin = keccak256("DeveloperAdmin");
    bytes32 public constant PresidentAdmin = keccak256("PresidentAdmin");
    bytes32 public constant CommunicationsAdmin = keccak256("CommunicationsAdmin");
    bytes32 public constant DataAdmin = keccak256("DataAdmin");

    
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