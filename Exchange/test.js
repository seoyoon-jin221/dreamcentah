function initiateAccounts() {
  Exchange.deposit(eth.accounts[0], 'USD', 10000);
  Exchange.deposit(eth.accounts[1], 'USD', 10000);
  Exchange.deposit(eth.accounts[2], 'USD', 10000);
  Exchange.deposit(eth.accounts[3], 'USD', 10000);
  Exchange.deposit(eth.accounts[0], 'BitCoin', 10000);
  Exchange.deposit(eth.accounts[1], 'BitCoin', 10000);
  Exchange.deposit(eth.accounts[2], 'BitCoin', 10000);
  Exchange.deposit(eth.accounts[3], 'BitCoin', 10000);
  showBalance();
}

function showBalance() { 
  var USD0 = Exchange.getBalance(eth.accounts[0], 'USD');
  var USD1 = Exchange.getBalance(eth.accounts[1], 'USD');
  var USD2 = Exchange.getBalance(eth.accounts[2], 'USD');
  var USD3 = Exchange.getBalance(eth.accounts[3], 'USD');
  
  var BitCoin0 = Exchange.getBalance(eth.accounts[0], 'BitCoin');
  var BitCoin1 = Exchange.getBalance(eth.accounts[1], 'BitCoin');
  var BitCoin2 = Exchange.getBalance(eth.accounts[2], 'BitCoin');
  var BitCoin3 = Exchange.getBalance(eth.accounts[3], 'BitCoin');
  
  console.log('0 + USD: ' + USD0 + ' BitCoin: ' + BitCoin0);
  console.log('1 + USD: ' + USD1 + ' BitCoin: ' + BitCoin1);
  console.log('2 + USD: ' + USD2 + ' BitCoin: ' + BitCoin2);
  console.log('3 + USD: ' + USD3 + ' BitCoin: ' + BitCoin3);

}

function createLimitOrder(account, giveCurrency, getCurrency, price, amount) {
  var randomNumber = Math.random() * 1000; //solidity doesn't support decimal points
  var orderkey = Exchange.getOrderKey(randomNumber);
  Exchange.createlimitOrder(account, orderKey, gieCurerncy, getCurrency, price, amount);
}
