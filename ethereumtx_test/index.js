const Web3 = require('web3');
const EthereumTx = require('ethereumjs-tx');
const fs = require('fs');

web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io"));

var Syncdata = fs.readFileSync('PrivateKey.txt','utf8');
var privateKey = Buffer.from(Syncdata, 'hex');

var nce = web3.eth.getTransactionCount("0xC39BBb80FbAb2738E358FC9C03cd69AA410c68C0"); 
nce = web3.toHex(nce);
var rawTx = {
		 nonce: nce,
		 gasPrice: '0x09184e72a000',
		 gasLimit: '0x30000',
		 to: '0xa3c84a57f0995504b78476884f5ceDE50B733C47',	//Account2
		 value: web3.toHex(web3.toWei('0.01','ether')), 
		 data: '0x1234',
		}
		
var tx = new EthereumTx(rawTx);
		tx.sign(privateKey);
		
var serializedTx = tx.serialize();
		web3.eth.sendRawTransaction('0x' + serializedTx.toString('hex'), function(err, hash) {
		 if (!err)
			console.log(hash);
		 else
			console.log(err);
});
