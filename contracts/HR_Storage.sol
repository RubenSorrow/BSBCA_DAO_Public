// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./HR_AccessManagement.sol";
import "./Membership_Storage.sol";
    

contract HR_Storage is HR_AccessManagement {
    
    Membership_Storage private stor;
    
    uint32 private HumanResources;
    
    constructor(address addr) {
        stor = Membership_Storage(addr);
        
        _setRoleAdmin(HR_Role, HR_Admin);
        _setRoleAdmin(DeveloperRole, DeveloperAdmin);   
        _setRoleAdmin(AppRole, DeveloperAdmin);
        
        _setupRole(HR_Admin, address(this));
        _setupRole(DeveloperAdmin, _msgSender());   
        _setupRole(DeveloperRole, _msgSender());
    }
    
    //heads getters
    function getHeadOfHR() public view returns(uint32) {
        return HumanResources;
    }
    
     //heads SETTERS
    function setHeadOfHR(uint32 id) public onlyApps() {
        require(stor._isMember(id),"storage ERROR: This student is not in the association");
        this.revokeRole(HR_Role, stor._idToAddress(HumanResources));
        
        this.grantRole(HR_Role, stor._idToAddress(id));
        HumanResources = id;
    }
    
}