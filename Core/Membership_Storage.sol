// SPDX-License-Identifier: MIT


pragma solidity >=0.6.2 <0.8.0;

import "../Membership_AccessManagement.sol";
    

contract Membership_Storage is Membership_AccessManagement {
    
    
    event PresidentChanged(uint32 indexed to, address indexed sender);
    event MemberAdded(uint32 indexed id, address indexed addr,address indexed sender);
    event MemberDeleted(uint32 indexed id, address indexed addr, address indexed sender);
    
    //roles
    enum Role {nul, President, Communications, Data, Events, HR, BD, Research, Marketing}
    
    //counters
    uint16 private tot_Members;
    
    //heads
    uint32 private President;
    uint32 private Communications;
    uint32 private Data;
    
    //basic mappings for membership
    mapping(uint32 => bool) private isMember;
    mapping(address => uint32) private addressToID;
    mapping(uint32 => address) private idToAddress;
    mapping(uint32 => Role) private idToRole;
    
    //utility mappings
    mapping(address => bool) private isAddressUsed;
    
    constructor() public {
        _setRoleAdmin(PresidentRole, PresidentAdmin);
        _setRoleAdmin(CommunicationsRole, CommunicationsAdmin);
        _setRoleAdmin(DataRole, DataAdmin);
        _setRoleAdmin(DeveloperRole, DeveloperAdmin);   
        _setRoleAdmin(AppRole, DeveloperAdmin);
        
        _setupRole(PresidentAdmin, address(this));
        _setupRole(CommunicationsAdmin, address(this));
        _setupRole(DataAdmin, address(this));
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
    function getCommunications() public view returns(uint32) {
        return Communications;
    }function getData() public view returns(uint32) {
        return Data;
    }
    
    //mappings getters
    function _addressToID(address addr) public view returns(uint32) {
        return addressToID[addr];
    }
    function _idToAddress(uint32 id) public view returns(address) {
        return idToAddress[id];
    }
    function _idToRole(uint32 id) public view returns(Role) {
        return idToRole[id];
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
        delete idToRole[President];
        
        //uploads the new one and grants roles
        President = id;     
        idToRole[id] = Role.President;
        this.grantRole(PresidentRole, idToAddress[id]);
        
        return true;
    }
    function setCommunications(uint32 id) public onlyApps() memberCheck(id) {
        this.revokeRole(CommunicationsRole, idToAddress[Communications]);
        delete idToRole[Communications];
        
        this.grantRole(CommunicationsRole, idToAddress[id]);
        Communications = id;
        idToRole[id] = Role.Communications;
        
    }
    function setData(uint32 id) public onlyApps() memberCheck(id) {
        this.revokeRole(DataRole, idToAddress[Data]);
        delete idToRole[Data];
        
        this.grantRole(DataRole, idToAddress[id]);
        Data = id;
        idToRole[id] = Role.Data;
    }
    
    
    function setIDtoAddress(uint32 id,address addr) public onlyApps() memberCheck(id) {         
        idToAddress[id] = addr;
        addressToID[addr] = id;     //Sets the opposite one too
    }
    function setIDtoRole(uint32 id,Role role) public onlyApps() memberCheck(id) {
        idToRole[id] = role;
    }
    
    
    function addMember(uint32 id,address addr,Role role) onlyApps() public returns(bool) {
        /*
        *  @dev President, Head of Communications and Data Manager cannot be added   
        *
        */
        require(isMember[id] == false,"storage ERROR: This student is already in the association");
        require(isAddressUsed[addr] == false, "storage ERROR: This address has been already used");
        require(role != Role.President,"storage ERROR: You cannot add the President");
        require(role != Role.Data, "storage ERROR: You cannot add a the Data Manager");
        require(role != Role.Communications, "storage ERROR: You cannot add a head the head of Communications");
        
        emit MemberAdded(id, addr, _msgSender());
        
        tot_Members++;                  //increases number of members
        addressToID[addr] = id;         //compiles the mappings
        idToAddress[id] = addr;         
        idToRole[id] = role;            
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
        require(id != (President), "storage ERROR: You cannot delete a head member");
        require(id != (Communications), "storage ERROR: You cannot delete a head member");
        require(id != (Data), "storage ERROR: You cannot delete a head member");
    
        emit MemberDeleted(id, addr, _msgSender());
        
        tot_Members--;                  //decreases the number of members
        delete idToAddress[id];         //deletes/resets mappings
        delete addressToID[addr];
        delete idToRole[id];
        isMember[id] = false;
        isAddressUsed[addr] = false;
        
        return true;
        
    }
}
