/// <reference types="react-scripts" />

interface Window {
  ethereum: any
}

interface ConnectProps {
  account: string;
  setAccount: Function;
  web3: {
    eth: {
      requestAccounts: Function;
    };
  };
}

interface GiveReactionProps {
  account: string;
  contract: {
    methods: {
      react: Function;
      getNumberOfSymbolsRecieved: Function;
    };
  };
  web3: {
    utils: {
      isAddress: Function;
    };
  };
}

interface ProfileParams {
  account: string;
}