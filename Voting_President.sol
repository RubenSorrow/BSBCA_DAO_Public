// SPDX-License-Identifier: MIT


pragma solidity >=0.6.0 <0.8.0;

import "./Membership_Storage.sol";


contract VotingPresident is Context {
    
    //events
    event NewCandidate(address indexed addr, uint32 indexed id);
    event ElectionsStarted(uint indexed timestamp, uint32 indexed developerId);
    event ElectionsEnded(uint indexed timestamp,uint32 indexed winner, uint32 indexed developerId);
    event BallotStarted(uint indexed timestamp,uint32[5] indexed candidates, uint32 indexed developerId);
    
    
    enum State {nul, started, ballot}
    State actualState;
    
    Membership_Storage private stor;
    
    uint32[5] private candidates = [0,0,0,0,0];
    uint32[5] private ballotList = [0,0,0,0,0];
    mapping(uint32 => uint8) private candidateToVotes;
    
    uint private voteTime;
    mapping(uint32 => uint) private lastVoteTime;
    
    constructor(address addr) {
        stor = Membership_Storage(addr);
    }
    
    //modifiers
    modifier onlyDevelopers() {
        require(stor.hasRole(keccak256("Developer"),_msgSender()),"app ERROR: THe sender must be a Developer");
        _;
    }
    
    modifier hasStarted() {
        require(actualState != State.nul,"app ERROR: The elections have not started yet");
        _;
    }
    
    modifier onlyMembers() {
        require(stor._isMember(stor._addressToID(_msgSender())),"app ERROR: The sender is not in the association");
        _;
    }
    
    //utilities
    function isInList(uint32 id,uint32[5] memory list) private pure returns(bool){
        for(uint8 i=0;i<5;i++){
            if(id == list[i]){
                return true;
            }
        }
        
        return false;
    }
    
    function checkDraw() private view returns(bool){
        uint8 draw;
        uint8 higher;
        
        for(uint8 i=0;i<5;i++){
            if(candidateToVotes[candidates[i]] == higher){
                draw = higher;
            }
            else if(candidateToVotes[candidates[i]] > higher){
                higher = candidateToVotes[candidates[i]];
            }
        }
        
        if(draw == higher){
            return true;
        } else {
            return false;
        }
    }
    function freeIndex(uint32[5] memory list) private pure returns(uint256) {
        for(uint8 i = 0; i<5; i++){
            if(list[i] == 0){
                return i;
            }
        }
        return 10;
    }
    function hasVoted(uint32 id) public view returns(bool){
        if(lastVoteTime[id] >= voteTime){
            return true;
        } else {
            return false;
        }
    }
    
    //getters
    function getState() public view returns(State){
        return actualState;
    }
    function getCandidates() public view returns(uint32[5] memory){
        return candidates;
    }
    function getVotes(uint32 id) public view returns(uint8) {
        require(isInList(id,candidates),"app ERROR: This ID is not a candidate");
        
        return candidateToVotes[id];
    }
    function getCurrentWinners() public view returns(uint32[5] memory){
        uint8 higher = 0;
        uint32[5] memory output;
        
        for(uint8 i=0;i<5;i++){
            if(candidateToVotes[candidates[i]] > higher){
                higher = candidateToVotes[candidates[i]];
            }
        }
        
        for(uint8 i=0;i<5;i++){
            if(candidateToVotes[candidates[i]] == higher){
                output[freeIndex(output)] = candidates[i];
            }
        }
        
        return output;
    }
    
    //setters
    function startElections() public onlyDevelopers() returns(bool) {
        emit ElectionsStarted(block.timestamp,stor._addressToID(_msgSender()));
        
        for(uint8 i=0;i<5;i++){
            delete candidateToVotes[candidates[i]];
            delete candidates[i];
        }
        
        actualState = State.started;
        voteTime = block.timestamp;
        
        return true;
    }
    
    function endElections() public onlyDevelopers() hasStarted() returns(bool){
        require(!checkDraw(),"app ERROR: It's a draw!");
        emit ElectionsEnded(block.timestamp,getCurrentWinners()[0],stor._addressToID(_msgSender()));
        
        actualState = State.nul;
        
        stor.setPresident(getCurrentWinners()[0]);
        
        return true;
    }
    
    function launchBallot() public onlyDevelopers() hasStarted() returns(bool){
        require(checkDraw(),"app ERROR: There's an absolute winner!");
        
        emit BallotStarted(block.timestamp,getCurrentWinners(),stor._addressToID(_msgSender()));
        
        for(uint8 i=0;i<5;i++){
            delete ballotList[i];
        }
        
        ballotList = getCurrentWinners();
        actualState = State.ballot;
        voteTime = block.timestamp;
        
        return true;
    }
    
    function candidate() public onlyMembers() hasStarted() returns(bool){
        require(!isInList(stor._addressToID(_msgSender()),candidates),"app ERROR: The sender is already a candidate");
        emit NewCandidate(_msgSender(),stor._addressToID(_msgSender()));
        
        candidates[freeIndex(candidates)] = stor._addressToID(_msgSender());
        
        return true;
    }
    
    function vote(uint32 id) public onlyMembers() hasStarted() {
        require(isInList(id,candidates),"app ERROR: The voted ID is not in the association");
        require(!hasVoted(stor._addressToID(_msgSender())),"app ERROR: The sender has already voted");
        
        if(actualState == State.ballot){
            if(!isInList(id,ballotList)){
                revert("app ERROR: The candidate is not in the ballot list");
            }
        }
        
        candidateToVotes[id] ++;
        lastVoteTime[stor._addressToID(_msgSender())] = block.timestamp;
    }
}