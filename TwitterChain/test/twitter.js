var Twitter = artifacts.require("./Twitter.sol");

contract('Twitter', function(accounts) {
  it("should return 58", function() {
    return Twitter.deployed().then(function(instance) {
      assert.equal(instance.followers.valueOf(), 58, "should be 58");
    })
  });
});
