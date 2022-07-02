/// <reference types="react-scripts" />

interface Window {
  ethereum: any
}

interface ConnectProps {
  account: string;
  setAccount: Function;
}

interface GiveReactionProps {
  account: string;
}