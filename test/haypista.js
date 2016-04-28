contract('Haypista', function(accounts) {

	it("should assert true", function(done) {
		var thePista = Haypista.at(Haypista.deployed_address);
		assert.isTrue(true);
		done(); // stops tests at this point
	});



	it("Initial thePista settings should match", function(done) {
		var thePista = Haypista.at(Haypista.deployed_address);
		var weiAmount = web3.toWei(.05, 'ether');
		// var gameId = block.number;

		Haypista.new({ from: accounts[0] }).then(function(thePista) {

				thePista.defaultAmount.call().then(function(defaultAmount) {
		      		assert.equal(defaultAmount, weiAmount, "Default amount doesn't match!");
		      		return thePista.feeRate.call();
		    	}).then( function(feeRate) {
		      		assert.equal(feeRate, 45 / 10000, "Fee Rate doesn't match!");
		      		return thePista.name.call();
		      	}).then( function(name) {
		      		assert.equal(name, 'The Pista', "name doesn't match!");
		      		return thePista.manager.call();
		    	}).then( function(manager) {
		      		assert.equal(manager, accounts[0], "manager doesn't match!");
		      		done();
		    	}).catch(done);

		}).catch(done);

	});



/*

	it("should create Haypista by manager", function(done) {

	    // Get a reference to the deployed Haypista contract, as a JS object.
	    var pista = Haypista.deployed();

		// Get initial balances of first and second account.
		var managerAcct = accounts[0];
		var playerAcct = accounts[1];

    	// Get the Haypista defaultAmount of the first account, and assert that it's 1000.
    	pista.getDefaultAmount.call(managerAcct).then(function(defaultAmount) {
      		assert.equal(defaultAmount.valueOf(), 1000, "1000 wasn't in the first account");
    	}).then(done).catch(done);

    	// Get the Haypista feeRate of the first account, and assert that it's 1000.
    	pista.getFeeRate.call(managerAcct).then(function(feeRate) {
      		assert.equal(feeRate.valueOf(), 45 / 10000, "45 / 10000 wasn't in the first account");
    	}).then(done).catch(done);

    	// Get the Haypista name of the first account, and assert that it's 'The Pista'.
    	pista.getName.call(managerAcct).then(function(name) {
      		assert.equal(name.valueOf(), 'The Pista', "'The Pista' wasn't in the first account");
    	}).then(done).catch(done);






	});





	it("should add a addPista by manager", function(done) {});
	it("should set a setHomeAway by manager", function(done) {});
	it("should set a setStarts by manager", function(done) {});
	it("should create a initialize", function(done) {});
	it("should process a processWinning", function(done) {});
	it("should send a sendRefund", function(done) {});
	it("should set a setPlayerScore", function(done) {});
	it("should set a setPointSystem", function(done) {});
	it("should set a setDefaultAmount", function(done) {});
	it("should get a getDefaultAmount", function(done) {});
	it("should set a setFeeRate", function(done) {});
	it("should get a getFeeRate", function(done) {});
	it("should set a setCreated", function(done) {});
	it("should set a setStarted", function(done) {});
	it("should set a setFinished", function(done) {});
	it("should set a setName", function(done) {});
	it("should get a getName", function(done) {});
	it("should set a setScore", function(done) {});
	it("should set a setPlayerPoints", function(done) {});
	it("should set a setOneXTwo", function(done) {});
	it("should set a setPistaScore", function(done) {});
	it("should deposit a depositPlayerWin", function(done) {});
	it("should send a sendWinnings", function(done) {});




somecall.call(...).then(function(ret) {
  // assert some stuff }
  return somecall.call(…);
}).then(function(ret) {
  // assert some stuff }
  return somecall.call(…);
}).then(function(ret) {
  // assert some stuff }
  return somecall.call(…);
}).then(function(ret) {
  // assert some stuff }
  return somecall.call(…);
}).then(done).catch(done);




contract('Haypista', function(accounts) {
  it("should put 1000 Haypista in the first account", function(done) {
    // Get a reference to the deployed Haypista contract, as a JS object.
    var pista = Haypista.deployed();

    // Get the Haypista defaultAmount of the first account, and assert that it's 1000.
    pista.getDefaultAmount.call(accounts[0]).then(function(defaultAmount) {
      assert.equal(defaultAmount.valueOf(), 1000, "1000 wasn't in the first account");
    }).then(done).catch(done);
  });
});














it("should have a default name", function(done) {

	// Get a reference to the deployed Haypista contract, as a JS object.
  var pista = Haypista.deployed();

  // Get the Haypista name.
  pista.getName.call().then(function(name) {
    assert.equal(name.valueOf(), 'The Pista', "The Pista was not the name found!");
  }).then(done).catch(done);
});


	it('should create a new pista by manager', function(done) {

	  	// Get a reference to the deployed Haypista contract, as a JS object.
	    var pista = Haypista.deployed();

		// ...
		var manager_account = accounts[0];
	    var manager_account_starting_defaultAmount;
	    var account_two_starting_defaultAmount;
	    var manager_account_ending_defaultAmount;
	    var account_two_ending_defaultAmount;

	    var amount = 10;

	    pista.getDefaultAmount.call(manager_account).then(function(defaultAmount) {
	      manager_account_starting_defaultAmount = defaultAmount.toNumber();
	      return pista.getDefaultAmount.call(account_two);
	    }).then(function(defaultAmount) {
	      account_two_starting_defaultAmount = defaultAmount.toNumber();
	      return pista.sendCoin(account_two, amount, {from: manager_account});
	    }).then(function() {
	      return pista.getDefaultAmount.call(manager_account);
	    }).then(function(defaultAmount) {
	      manager_account_ending_defaultAmount = defaultAmount.toNumber();
	      return pista.getDefaultAmount.call(account_two);
	    }).then(function(defaultAmount) {
	      account_two_ending_defaultAmount = defaultAmount.toNumber();

	      assert.equal(manager_account_ending_defaultAmount, manager_account_starting_defaultAmount - amount, "Amount wasn't correctly taken from the sender");
	      assert.equal(account_two_ending_defaultAmount, account_two_starting_defaultAmount + amount, "Amount wasn't correctly sent to the receiver");
	    }).then(done).catch(done);

	});





*/


});
