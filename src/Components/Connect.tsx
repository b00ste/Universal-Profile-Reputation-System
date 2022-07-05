import "./Connect.css";

const Connect = ({ account, setAccount, web3 }:ConnectProps) => {

  const connect = async () => {
    const accountsRequest: string[] = await web3.eth.requestAccounts();  
    setAccount(accountsRequest[0]);
  }

  return (
    <>
    {
      account === ''
      ? <div className='connect-btn-container'>
          <div className='connect-btn-background'/>
          <div className='connect-btn-form'>
            <p className='connect-btn-text'>
              Please Connect with a Universal Profile browser extension. If you didn't install it yet, you can follow instructions on:
            </p>
            <a className='connect-btn-link' target="_blank" rel='noreferrer' href='https://docs.lukso.tech/guides/universal-profile/browser-extension/install-browser-extension/'>UP Browser Extension</a>
            <button className='connect-btn connect' onClick={() => connect()}>connect</button>
          </div>
        </div>
      : <></>
    }
    </>
  );
}

export default Connect;