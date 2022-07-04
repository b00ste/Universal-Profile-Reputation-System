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

interface SendPillsProps {
  account: Object;
  pinkPill: {
    methods: {
      transfer: Function;
      balanceOf: Function;
    };
  };
  greenPill: {
    methods: {
      transfer: Function;
      balanceOf: Function;
    };
  };
  pills: {
    pink: number;
    green: number;
  };
  setPills: Function;
}

interface ProfileParams {
  account: string;
  contract: {
    methods: {
      getNumberOfReactionsRecieved: Function;
    };
  };
}