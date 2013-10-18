require 'hashie'
require "rodger/version"

class AccountTree < Hash
  # AccountTree is just a hash, but we make a separate class of it
  # _ to not pollute the Hash class with our Hashie extensions
  # - incase we want to funk it up later
  # - to give us some type information

  include Hashie::Extensions::MergeInitializer


  # deep merge merges two AccountTrees such that their sub-account-trees are merged as well
  # frankly, I can not now work out why this code works but the specs pass and so....
  def deep_merge (h)
    self.merge(h) do |k, old, new|
      begin
        AccountTree.new(old).deep_merge(AccountTree.new(new))
      rescue
        new
      end
    end
  end

  # returns true if an account has no sub accounts
  def leaf?
    (keys - [:name, :balance]).empty?
  end

end

class Rodger

  # This class provides a Ruby API to ledger

  # WARNING - Currently only supports single currency

  [:filename, :report_type, :current, :begin, :end, :period, :period_sort, :cleared, :dc, :uncleared,
   :real, :actual, :related, :budget, :add_budget, :unbudgeted, :forecast, :limit, :amount, :total, :ledger].each do |a|
    attr_accessor a
  end

  # Initialize with the name of the filename and an optional path to the ledger binary
  #
  # options is a hash like
  # :file => path to the ledger file
  # :bin  => path to the ledger binary. Defaults to 'ledger' so not required if ledger is in your path
  def initialize(options = {})
    @filename = options[:file]
    @ledger = options[:bin] || 'ledger'
  end

  # Public: Builds a AccountTree of the accounts as reported by ledger. It populates each account with the canonical name and balance of the account
  # returns a Hash like {"Assets" => {:name => "Assets", :balance => <balance>, "Fixed Assets" => {:name => "Assets:FixedAssets", :bal...}}}
  def accounts
    ahash = (cmd "accounts | sort").split("\n")
    ahash.reduce(AccountTree.new) do |s, h|
      a = recurse_accounts(h.split(":"))            # recursion is awsm!
      s.deep_merge(a)
    end
  end

  # Public: Returns a hash of all the account names and their balances. Is the "flat" version of the accounts tree above
  # however, it does not include any accounts which do not have any journal entries in them.
  def balances
    return @balances_hash if @balances_hash
    ledger_balances = cmd 'bal --balance-format "%A | %(display_total)\n"'
    @balances_hash = Hash[*(ledger_balances.split("\n")).map{|line| parse_account_line(line)}.flatten]
  end

  # Public: Returns the account balance for a given account on a given date
  # Need to give the full name of the account, not a regexp to match against
  def balance(account)
    return balances[account] || infer_balance(account) # need to infer the balance if the account is not in ledger's output
  end

  private

  # Builds the command using the provided switches and any extra arguments used here
  def cmd(extra_args)
    `#{@ledger} -f #{@filename} #{extra_args}`
  end

  # given an array like [Assets][FixedAssets][Furniture], returns a Hash like
  # {"Assets" => {:name => "Assets", :balance => <balance>, "FixedAssets" => {...}...}...}
  # by querying the given ledger for balances, etc.
  def recurse_accounts(accounts_array, prenom = "")
    result = AccountTree.new
    prenom = prenom.empty? ? accounts_array[0] : "#{prenom}:#{accounts_array[0]}"
    if accounts_array.class == Array
      if accounts_array.size == 1
        result[accounts_array[0]] = AccountTree.new(:name => prenom, :balance => balance(prenom))
      else
        r = recurse_accounts(accounts_array[1..-1], prenom)
        result[accounts_array[0]] = r.merge(:name => prenom, :balance => balance(prenom))
      end
    end
    result
  end


  #Private: takes a line from ledger balance output and returns the account, amount and currency
  def parse_account_line(line)
    account = line.split("|")[0].strip rescue nil
    amount  = line.scan(/\-{0,1}\d+[\.\d+]*/)[0].to_f rescue nil
    currency = line.scan(/[A-Z]{3,7}/)[-1] rescue nil
    [account,{:amount => amount, :currency => currency}]
  end

  # If the given account is not found in the balance report, we have to infer the balance from the subaccounts
  # Please refer to the specs for more information
  #
  # account is an account name
  def infer_balance(account)
    sub_accounts = balances.keys.compact.map{|k| k.match(/#{account}:[^:]*/)}.compact
    relevant_accounts = sub_accounts.map(&:to_s).uniq
    relevant_account_balances = relevant_accounts.map{|a| balance(a)}
    balance = relevant_account_balances.reduce({:amount => 0, :currency => nil}){|s,h| {:amount => s[:amount] + h[:amount], :currency => h[:currency]}}
  end



end
