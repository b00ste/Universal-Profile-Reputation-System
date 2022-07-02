import Web3 from 'web3';
const web3 = new Web3(window.ethereum);

const Connect = ({ account, setAccount }:ConnectProps) => {

  const connect = async () => {
    const accountsRequest: string[] = await web3.eth.requestAccounts();  
    setAccount(accountsRequest[0]);
  }

  const disconnect = () => {
    setAccount('');
    window.location.reload();
  }

  /*window.ethereum.on('accountsChanged', function (accounts:string) {
    setAccount(account[0]);
  });*/

  return (
    <div className='connect'>
    {
      account === ''
      ? <button className='connect-btn' onClick={() => connect()}>Connect</button>
      : <button className='connect-btn' onClick={() => disconnect()}>Disconnect</button>
    }
    </div>
  );
}

export default Connect;