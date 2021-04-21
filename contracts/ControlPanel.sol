// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./Membership_Storage.sol";

contract ControlPanel is Context {
    
    //event approvalPush(address indexed addr, Membership_Storage.Role indexed by);
    //event approvalPull(address indexed addr, Membership_Storage.Role indexed by);
    //event teamChanged(address indexed addr, Membership_Storage.Role indexed from, Membership_Storage.Role indexed to);
    
    Membership_Storage private stor;
    
    mapping(address => bool) private approvalHR;
    mapping(address => bool) private approvalVP;
    mapping(address => bool) private approvalPresident;
    
    constructor(address addr) {
        stor = Membership_Storage(addr);
    }
    
    modifier onlyHR() {
        require(stor.hasRole(keccak256("VP"),_msgSender())||stor.hasRole(keccak256("HR"),_msgSender())||stor.hasRole(keccak256("President"),_msgSender()),"app ERROR: The sender is not authorized to perform this action");
        _;
    }
    
    function pushCheck(address addr) public view returns(bool) {
        if(approvalHR[addr]&&approvalVP[addr]&&approvalPresident[addr]){
            return true;
        }
        
        return false;
    }
    
    function pullCheck(address addr) public view returns(bool) {
        if(!approvalHR[addr]&&!approvalVP[addr]&&!approvalPresident[addr]){
            return true;
        }
        
        return false;
    }
    
    function approvePush(address addr) public onlyHR() returns(bool) {
        if(stor.hasRole(keccak256("HR"),_msgSender())){
            approvalHR[addr] = true;
        } else if(stor.hasRole(keccak256("VP"),_msgSender())){
            approvalVP[addr] = true;
        } else if(stor.hasRole(keccak256("President"),_msgSender())){
            approvalPresident[addr] = true;
        }
        
        //emit approvalPush(addr, stor._idToRole(stor._addressToID(_msgSender())));
        
        return true;
    }
    
    function approvePull(address addr) public onlyHR() returns(bool) {
        if(stor.hasRole(keccak256("HR"),_msgSender())){
            approvalHR[addr] = false;
        } else if(stor.hasRole(keccak256("VP"),_msgSender())){
            approvalVP[addr] = false;
        } else if(stor.hasRole(keccak256("President"),_msgSender())){
            approvalPresident[addr] = false;
        }
        
        //emit approvalPull(addr, stor._idToRole(stor._addressToID(_msgSender())));
        
        return true;
    }
    
    
    function pushMember(address addr, uint32 id) public onlyHR() {
        require(pushCheck(addr),"app ERROR: The address has not been approved yet");
        
        stor.addMember(id,addr);
    }
    
    function pullMember(address addr) public onlyHR() {
        require(pullCheck(addr),"app ERROR: The address has not been disapproved yet");
        
        stor.deleteMember(stor._addressToID(addr),addr);

    }
    
    /*function changeTeam(address addr, Membership_Storage.Role role) public returns(bool) {
        require(stor.hasRole(keccak256("HR"),_msgSender()),"app ERROR: The sender is not authorized to perform this action");
        
        emit teamChanged(addr, stor._idToRole(stor._addressToID(addr)),role);
        
        stor.setIDtoRole(stor._addressToID(addr),role);
        
        return true;
    }*/
    
    
    
}