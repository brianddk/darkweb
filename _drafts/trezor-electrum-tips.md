---
layout: post
title:  "Trezor Electrum Tips"
date: 2019-09-15 20:29:42 -0500
# categories: jekyll update
---

Trezor and Electrum offer a lot of options when used together.  There are currently, at least, [26 Trezor supported coins](
https://github.com/trezor/trezor-firmware/blob/master/common/defs/wallets.json
) that have Electrum forks available.  What I outline below will work on most of them.  I will also make use of [`trezorctl`](
https://wiki.trezor.io/Using_trezorctl_commands_with_Trezor
) which is the trezor command-line utility.

## Verifying Passphrase

One of the common problems with Trezor wallets are variances in passphrases.  Since all passphrases are valid, if someone mistypes a passphrase, they could send coins to a wallet they did not intent.  This is expecially problematic on new wallets with no transaction history.  Basically there is no verification of "correctness".  This can be fixed in two ways.  One in the Trezor web-wallet, and one in Electrum (for better or worse).  

#### Web-Wallet

To validate "correctness" of a passphrase in the web-wallet, simply enable labeling and label the account.  Labeling is tied to the current passphrase, so if your label does not show up, then you must have mistyped the passphrase.

#### Electrum

Electrum solves the problem in another way.  Electrum will (optionally) encrypt your wallet file with data from your current hardware wallet info.  This means if you enter a different passphrase your wallet info is changed and the decryption fails.  

#### Trezor Command-Line

For all of the above cases you should keep a copy of the accounts xpub, ypub or zpub and file it away.  This is the definitive "fingerprint" of your wallet.  At least for that coin/account.  The different "types" have to do with the derivation path and pay-to type.  Here are the commands to show each.

* xpub\m-44: `trezorctl get-public-node -c Bitcoin -n m/44'/0'/0' -t address`
* ypub\m-49: `trezorctl get-public-node -c Bitcoin -n m/49'/0'/0' -t p2shsegwit`
* xpub\m-84: `trezorctl get-public-node -c Bitcoin -n m/84'/0'/0' -t segwit`

Obviously the above is for the "Bitcoin" chain and for the "first" account, or Account[0].  For Litecoin or the second or third accounts, you would adjust your arguments.

## Native Segwit (zpub/bc1)

Although Trezor Web-Wallet does not support native-segwit yet, the firmware and command-line utility does, which give Electrum support in turn.

<!-- Todo Multisig -->