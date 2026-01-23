# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **DO NOT** open a public issue
2. Email security concerns to the project maintainers
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be addressed before public disclosure

## Smart Contract Security

- All contracts are written in Solidity 0.8.24+ with built-in overflow protection
- The contract uses the checks-effects-interactions pattern
- Reentrancy protections are implemented where necessary
- Owner functions are protected with the `onlyOwner` modifier

## Scope

The following are in scope for security reports:
- Smart contracts in the `src/` directory
- Deployment scripts in the `script/` directory

## Bug Bounty

We appreciate security researchers who help keep Mini Collectibles secure.
