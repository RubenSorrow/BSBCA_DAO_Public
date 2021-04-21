// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./Research_AccessManagement.sol";
import "./Membership_Storage.sol";
    

contract Research_Storage is Research_AccessManagement {
    
    Membership_Storage private stor;
    
    uint32 private Research;
    
    constructor(address addr) {
        stor = Membership_Storage(addr);
        
        _setRoleAdmin(ResearchRole, ResearchAdmin);
        _setRoleAdmin(DeveloperRole, DeveloperAdmin);   
        _setRoleAdmin(AppRole, DeveloperAdmin);
        
        _setupRole(ResearchAdmin, address(this));
        _setupRole(DeveloperAdmin, _msgSender());   
        _setupRole(DeveloperRole, _msgSender());
    }
    
    //heads getters
    function getHeadOfResearch() public view returns(uint32) {
        return Research;
    }
    
     //heads SETTERS
    function setHeadOfResearch(uint32 id) public onlyApps() {
        require(stor._isMember(id),"storage ERROR: This student is not in the association");
        this.revokeRole(ResearchRole, stor._idToAddress(Research));
        
        this.grantRole(ResearchRole, stor._idToAddress(id));
        Research = id;
    }
    
}