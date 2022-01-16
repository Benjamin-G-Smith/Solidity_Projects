//var Migrations = artifacts.require("./Migrations.sol");

var ItemManager = artifacts.require("./ItemManager.sol");
module.exports = function(deployer) {
deployer.deploy(ItemManager);
};
