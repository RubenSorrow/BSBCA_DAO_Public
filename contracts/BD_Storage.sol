// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./BD_AccessManagement.sol";
import "./Membership_Storage.sol";
    

contract BD_Storage is BD_AccessManagement {
    
    Membership_Storage private stor;
    
    uint32 private BusinessDevelopment;
    
    constructor(address addr) {
        stor = Membership_Storage(addr);
        
        _setRoleAdmin(BD_Role, BD_Admin);
        _setRoleAdmin(DeveloperRole, DeveloperAdmin);   
        _setRoleAdmin(AppRole, DeveloperAdmin);
        
        _setupRole(BD_Admin, address(this));
        _setupRole(DeveloperAdmin, _msgSender());   
        _setupRole(DeveloperRole, _msgSender());
    }

    //heads getters
    function getHeadOfBD() public view returns(uint32) {
        return BusinessDevelopment;
    }
    
     //heads SETTERS
    function setHeadOfBD(uint32 id) public onlyApps() {
        require(stor._isMember(id),"storage ERROR: This student is not in the association");
        this.revokeRole(BD_Role, stor._idToAddress(BusinessDevelopment));
        
        this.grantRole(BD_Role, stor._idToAddress(id));
        BusinessDevelopment = id;
    }
    
}