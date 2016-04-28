// Factory "morphs" into a Pudding class.
// The reasoning is that calling load in each context
// is cumbersome.

(function() {

  var contract_data = {
    abi: [{"constant":false,"inputs":[{"name":"receiver","type":"address"},{"name":"amount","type":"uint256"}],"name":"sendCoin","outputs":[{"name":"sufficient","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"getBalance","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"inputs":[],"type":"constructor"}],
    binary: "6060604052600160a060020a03321660009081526020819052604090206127109055609f80602d6000396000f3606060405260e060020a600035046390b98a1181146024578063f8b2cb4f146050575b005b606c60043560243533600160a060020a0316600090815260208190526040812054829010156076576099565b600160a060020a03600435166000908152602081905260409020545b6060908152602090f35b604080822080548490039055600160a060020a0384168252902080548201905560015b9291505056",
    unlinked_binary: "6060604052600160a060020a03321660009081526020819052604090206127109055609f80602d6000396000f3606060405260e060020a600035046390b98a1181146024578063f8b2cb4f146050575b005b606c60043560243533600160a060020a0316600090815260208190526040812054829010156076576099565b600160a060020a03600435166000908152602081905260409020545b6060908152602090f35b604080822080548490039055600160a060020a0384168252902080548201905560015b9291505056",
    address: "0x9cb3fd239065a9cc910e73700bffd7cd2b86fffe",
    generated_with: "2.0.6",
    contract_name: "MetaCoin"
  };

  function Contract() {
    if (Contract.Pudding == null) {
      throw new Error("MetaCoin error: Please call load() first before creating new instance of this contract.");
    }

    Contract.Pudding.apply(this, arguments);
  };

  Contract.load = function(Pudding) {
    Contract.Pudding = Pudding;

    Pudding.whisk(contract_data, Contract);

    // Return itself for backwards compatibility.
    return Contract;
  }

  Contract.new = function() {
    if (Contract.Pudding == null) {
      throw new Error("MetaCoin error: Please call load() first before calling new().");
    }

    return Contract.Pudding.new.apply(Contract, arguments);
  };

  Contract.at = function() {
    if (Contract.Pudding == null) {
      throw new Error("MetaCoin error: lease call load() first before calling at().");
    }

    return Contract.Pudding.at.apply(Contract, arguments);
  };

  Contract.deployed = function() {
    if (Contract.Pudding == null) {
      throw new Error("MetaCoin error: Please call load() first before calling deployed().");
    }

    return Contract.Pudding.deployed.apply(Contract, arguments);
  };

  if (typeof module != "undefined" && typeof module.exports != "undefined") {
    module.exports = Contract;
  } else {
    // There will only be one version of Pudding in the browser,
    // and we can use that.
    window.MetaCoin = Contract;
  }

})();
