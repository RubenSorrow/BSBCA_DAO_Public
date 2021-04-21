// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./Marketing_AccessManagement.sol";
import "./Membership_Storage.sol";
    

contract Marketing_Storage is Marketing_AccessManagement {
    
    Membership_Storage private stor;
    
    uint32 private Marketing;
    
    constructor(address addr) {
        stor = Membership_Storage(addr);
        
        _setRoleAdmin(MarketingRole, MarketingAdmin);
        _setRoleAdmin(DeveloperRole, DeveloperAdmin);   
        _setRoleAdmin(AppRole, DeveloperAdmin);
        
        _setupRole(MarketingAdmin, address(this));
        _setupRole(DeveloperAdmin, _msgSender());   
        _setupRole(DeveloperRole, _msgSender());
    }
    
    //heads getters
    function getHeadOfMarketing() public view returns(uint32) {
        return Marketing;
    }
    
     //heads SETTERS
    function setHeadOfMarketing(uint32 id) public onlyApps() {
        require(stor._isMember(id),"storage ERROR: This student is not in the association");
        this.revokeRole(MarketingRole, stor._idToAddress(Marketing));
        
        this.grantRole(MarketingRole, stor._idToAddress(id));
        Marketing = id;
    }
    
}