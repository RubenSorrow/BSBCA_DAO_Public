// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./Membership_AccessManagement.sol";
    

contract Membership_Storage is Membership_AccessManagement {
    
    
    event PresidentChanged(uint32 indexed to, address indexed sender);
    event vpChanged(uint32 indexed to, address indexed sender);
    event MemberAdded(uint32 indexed id, address indexed addr,address indexed sender);
    event MemberDeleted(uint32 indexed id, address indexed addr, address indexed sender);
    
    //counters
    uint16 private tot_Members;
    
    //heads
    uint32 private President;
    uint32 private VP;
    
    //basic mappings for membership
    mapping(uint32 => bool) private isMember;
    mapping(address => uint32) private addressToID;
    mapping(uint32 => address) private idToAddress;
    
    //utility mappings
    mapping(address => bool) private isAddressUsed;
    
    constructor() {
        _setRoleAdmin(PresidentRole, PresidentAdmin);
        _setRoleAdmin(VP_Role, VP_Admin);
        _setRoleAdmin(DeveloperRole, DeveloperAdmin);   
        _setRoleAdmin(AppRole, DeveloperAdmin);
        
        _setupRole(PresidentAdmin, address(this));
        _setupRole(VP_Admin, address(this));
        _setupRole(DeveloperAdmin, _msgSender());       
        _setupRole(DeveloperRole, _msgSender());
    }
    
    
    //MODIFIERS
    modifier memberCheck(uint32 id) {
        require(isMember[id],"storage ERROR: This student is not in the association");
        _;
    }
    
    //heads getters
    function getPresident() public view returns(uint32) {
        return President;
    }
    function getVP() public view returns(uint32) {
        return VP;
    }
    
    //mappings getters
    function _addressToID(address addr) public view returns(uint32) {
        return addressToID[addr];
    }
    function _idToAddress(uint32 id) public view returns(address) {
        return idToAddress[id];
    }
    function _isMember(uint32 id) public view returns(bool) {
        return isMember[id];
    }
    function _isAddressUsed(address addr) public view returns(bool) {
        return isAddressUsed[addr];
    }
    
    //counter getter
    function getTotMembers() public view returns(uint16){
        return tot_Members;
    }
    
    
     //heads SETTERS
    function setPresident(uint32 id) public onlyApps() memberCheck(id) returns(bool){
        emit PresidentChanged(id, _msgSender());
        
        //revokes the role from precedent president
        this.revokeRole(PresidentRole, idToAddress[President]);
        
        //uploads the new one and grants roles
        President = id;     
        this.grantRole(PresidentRole, idToAddress[id]);
        
        return true;
    }

    function setVP(uint32 id) public onlyApps() memberCheck(id) returns(bool) {
        emit vpChanged(id, _msgSender());

        this.revokeRole(VP_Role, idToAddress[VP]);
        
        this.grantRole(VP_Role, idToAddress[id]);
        VP = id;

        return true;
    }
    
    
    function setIDtoAddress(uint32 id,address addr) public onlyApps() memberCheck(id) {         
        idToAddress[id] = addr;
        addressToID[addr] = id;     //Sets the opposite one too
    }
    
    function addMember(uint32 id,address addr) onlyApps() public returns(bool) {
        /*
        *  @dev President, Head of Communications and Data Manager cannot be added   
        *
        */
        require(isMember[id] == false,"storage ERROR: This student is already in the association");
        require(isAddressUsed[addr] == false, "storage ERROR: This address has been already used");

        emit MemberAdded(id, addr, _msgSender());
        
        tot_Members++;                  //increases number of members
        addressToID[addr] = id;         //compiles the mappings
        idToAddress[id] = addr;                
        isMember[id] = true;   
        isAddressUsed[addr] = true;
        
        return true;
    }
    function deleteMember(uint32 id, address addr) public onlyApps() memberCheck(id) returns(bool) {
        /*
        *   @dev  President, Head of Communications and Data Manager cannot be deleted
        *   
        *
        */
        require(idToAddress[id] == addr, "storage ERROR: ID and address don't match");
        require(id != (President), "storage ERROR: You cannot delete the President");
        require(id != (VP), "storage ERROR: You cannot delete the Vice President");
    
        emit MemberDeleted(id, addr, _msgSender());
        
        tot_Members--;                  //decreases the number of members
        delete idToAddress[id];         //deletes/resets mappings
        delete addressToID[addr];
        isMember[id] = false;
        isAddressUsed[addr] = false;
        
        return true;
        
    }
}