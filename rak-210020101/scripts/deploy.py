from brownie import SmartBankAccount , accounts

def main():
      admin=accounts[0]

      SmartBankAccount.deploy({
        "from":admin
      })

    
      