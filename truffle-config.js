module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 9545,
      network_id: "*" // Match any network id
    },

    ganache: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    }
  },

  compilers: {
    solc: {
      version: '^0.5.0',
    },
  }
};
