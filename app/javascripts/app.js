// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import claims_artifacts from '../../build/contracts/Claims.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
var Claim = contract(claims_artifacts);
// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;
var address;
var account_address;
var company_account_address;

window.App = {
  start: function() {
    var self = this;

    // Bootstrap the Claim abstraction for Use.
    Claim.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      console.log(Claim)
      // $.getJSON('../../build/contracts/Claims.json', function(data) {
      //         console.log("loading claims json");
      //         // Get the necessary contract artifact file and instantiate it with truffle-contract.
      //         var ClaimArtifact = data;
      //         console.log(App.contracts);
      //         App.contracts.Claim = TruffleContract(ClaimArtifact);

      //         // Set the provider for our contract.
      //         App.contracts.Claim.setProvider(App.web3Provider);
      //         Claim = App.contracts.Claim;
      //       });

      accounts = accs;
      account_address = accounts[0];
      company_account_address = accounts[1];
      console.log(accounts)
    });
  },

  getNumberOfAcceptedClaimsHistory: function() {
    var self = this;

    var claim;
    Claim.deployed().then(function(instance) {
      claim = instance;
      return claim.getNumberOfAcceptedClaimsHistory.call(account, {from: account});
    }).then(function(value) {
      console.log("Accepted claims = " + value);
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting accpeted claims; see log.");
    });
  },

  // sendCoin: function() {
  //   var self = this;

  //   var amount = parseInt(document.getElementById("amount").value);
  //   var receiver = document.getElementById("receiver").value;

  //   this.setStatus("Initiating transaction... (please wait)");

  //   var meta;
  //   MetaCoin.deployed().then(function(instance) {
  //     meta = instance;
  //     return meta.sendCoin(receiver, amount, {from: account});
  //   }).then(function() {
  //     self.setStatus("Transaction complete!");
  //     self.refreshBalance();
  //   }).catch(function(e) {
  //     console.log(e);
  //     self.setStatus("Error sending coin; see log.");
  //   });
  // },

  proposeClaim: function() {
    var self = this;
    var claim;

    function compileInfo(){
      var description = document.getElementById("description_input");
      var amount = document.getElementById("amount_input");
      return account_address + company_account_address;
    };
    //var data = window.crypto.compileInfo
    var data = new TextEncoder('utf-8').encode("message").join("");
    console.log(company_account_address);
    Claim.deployed().then(function(instance) { 
      claim = instance ;
      return claim.proposeClaim(company_account_address, data, {from: account_address, gas: 400000 });
    }).then(function(value){
      console.log("claim proposed!" + value);
    }).catch(function(e) {
      console.log(e);
    });
  },

  getLastClaimNumber: function(){
    Claim.deployed().then(function(instance) {
      claim = instance; 
      return claim.getLastClaimNumber()
    })
  }
};


window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } 
  else {
    console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }

  App.start();
});
