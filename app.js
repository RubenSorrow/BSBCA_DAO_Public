let web3 = new Web3(Web3.givenProvider);

function initialize() {
	const connectButton = document.getElementById("connectButton");
	const contractAddress = "";
	const addApp = new web3.eth.Contract(addAppABI.abi, contractAddress);
	const form = document.getElementById("myForm");
	const isMetamaskInstalled = () => {
		return Boolean(ethereum)&&ethereum.isMetaMask;	//checks ethereum provider MetaMask
	}

	//connect button
	function connectButtonLayout() {
		if(!isMetamaskInstalled) {
			connectButton.innerText = "Install Metamask";
			connectButton.disabled = false;
			connectButton.onclick = () => {
				const onboarding = new MetaMaskOnboarding();
				onboarding.startOnboarding();
				connectButton.disabled = true;
			}
		} else {
			connectButton.innerText = "Connect";
			connectButton.disabled = false;
			connectButton.onclick = () => {
				ethereum.request({method: "eth_requestAccounts"});
				connectButton.disabled = true;
			}
		}
	}

	connectButtonLayout();

	//form
	function pushMember() {
		addApp.methods.newMember(document.getElementById("ID").value,document.getElementById("address").value).send(
			{from: ethereum.selectedAddress});
	}
	
	function handleForm(event) {
		event.preventDefault(); //stops page refresh
		pushMember();
	} 

	form.addEventListener('submit', handleForm);

	

}

window.addEventListener("DOMContentLoaded",initialize);
