// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./Events_AccessManagement.sol";
import "./Membership_Storage.sol";
    

contract Events_Storage is Events_AccessManagement {
    
    Membership_Storage private stor;
    
    uint32 private Events;
    
    constructor(address addr) {
        stor = Membership_Storage(addr);
        
        _setRoleAdmin(EventsRole, EventsAdmin);
        _setRoleAdmin(DeveloperRole, DeveloperAdmin);   
        _setRoleAdmin(AppRole, DeveloperAdmin);
        
        _setupRole(EventsAdmin, address(this));
        _setupRole(DeveloperAdmin, _msgSender());   
        _setupRole(DeveloperRole, _msgSender());
    }
    
    //heads getters
    function getHeadOfEvents() public view returns(uint32) {
        return Events;
    }
    
     //heads SETTERS
    function setHeadOfEvents(uint32 id) public onlyApps() {
        require(stor._isMember(id),"storage ERROR: This student is not in the association");
        this.revokeRole(EventsRole, stor._idToAddress(Events));
        
        this.grantRole(EventsRole, stor._idToAddress(id));
        Events = id;
    }
    
}