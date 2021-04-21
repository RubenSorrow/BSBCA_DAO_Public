const Migrations = artifacts.require("Migrations");
const BD_AccessManagement = artifacts.require("BD_AccessManagement");
const BD_Storage = artifacts.require("BD_Storage");
const ControlPanel = artifacts.require("ControlPanel");
const Events_AccessManagement = artifacts.require("Events_AccessManagement");
const Events_Storage = artifacts.require("Events_Storage");
const Marketing_AccessManagement = artifacts.require("Marketing_AccessManagement");
const Marketing_Storage = artifacts.require("Marketing_Storage");
const Membership_AccessManagement = artifacts.require("Membership_AccessManagement");
const Membership_Storage = artifacts.require("Membership_Storage");
const Research_AccessManagement = artifacts.require("Research_AccessManagement");
const Research_Storage = artifacts.require("Research_Storage");
const Trading_AccessManagement = artifacts.require("Trading_AccessManagement");
const Trading_Storage = artifacts.require("Trading_Storage");
const VotingPresident = artifacts.require("VotingPresident");
const addApp = artifacts.require("addApp");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Membership_Storage).then(function() {
  	return deployer.deploy(BD_Storage,Membership_Storage.address);});
  deployer.deploy(Events_Storage,Membership_Storage.address);
  deployer.deploy(Marketing_Storage,Membership_Storage.address);
  deployer.deploy(Research_Storage,Membership_Storage.address);
  deployer.deploy(Trading_Storage,Membership_Storage.address);
  deployer.deploy(ControlPanel,Membership_Storage.address);
  deployer.deploy(VotingPresident,Membership_Storage.address);
  deployer.deploy(addApp,Membership_Storage.address);
};
