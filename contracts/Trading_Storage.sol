// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./Trading_AccessManagement.sol";
import "./Membership_Storage.sol";
    

contract Trading_Storage is Trading_AccessManagement {
    
    Membership_Storage private stor;
    
    uint32 private Trading;
    
    constructor(address addr) {
        stor = Membership_Storage(addr);
        
        _setRoleAdmin(TradingRole, TradingAdmin);
        _setRoleAdmin(DeveloperRole, DeveloperAdmin);   
        _setRoleAdmin(AppRole, DeveloperAdmin);
        
        _setupRole(TradingAdmin, address(this));
        _setupRole(DeveloperAdmin, _msgSender());   
        _setupRole(DeveloperRole, _msgSender());
    }

    //heads getters
    function getHeadOfTrading() public view returns(uint32) {
        return Trading;
    }
    
     //heads SETTERS
    function setHeadOfBD(uint32 id) public onlyApps() {
        require(stor._isMember(id),"storage ERROR: This student is not in the association");
        this.revokeRole(TradingRole, stor._idToAddress(Trading));
        
        this.grantRole(TradingRole, stor._idToAddress(id));
        Trading = id;
    }
    
}