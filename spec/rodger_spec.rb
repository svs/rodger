require './lib/rodger.rb'

describe Rodger do

  [:filename, :report_type, :current, :begin, :end, :period, :period_sort, :cleared, :dc, :uncleared,
   :real, :actual, :related, :budget, :add_budget, :unbudgeted, :forecast, :limit, :amount, :total].each do |a|
    it {should respond_to a}
  end


  describe "accounts" do
    describe "small file" do
      before :all do
        @r = Rodger.new(:file => 'spec/spec.dat', :bin => 'ledger')
      end

      it "should return an AccountTree" do
        @r.accounts.should be_a AccountTree
      end

      it "should give correct AccountTree" do
        @r.accounts.should == {
          "Assets" => {
            "Checking" => {
              :name => "Assets:Checking", :balance => {:amount => 110.0, :currency => nil},
              "Jumping" => {
                :name => "Assets:Checking:Jumping", :balance => {:amount => 100.0, :currency => nil}
              }
            },
            :name => "Assets", :balance => {:amount => 110.0, :currency => nil},
          },
          "Liabilities" => {
            "Saving" => {
              :name => "Liabilities:Saving", :balance => {:amount => -110.0, :currency => nil},
              "Sleeping" => {
                :name => "Liabilities:Saving:Sleeping", :balance => {:amount => -100.0, :currency => nil}
              }
            },
            :name => "Liabilities", :balance => {:amount => -110.0, :currency => nil}

        }
        }
      end
    end
    describe "big file" do
      before :all do
        @r = Rodger.new(:file => 'spec/demo.ledger.txt', :bin => 'ledger')
      end

      it "should give correct list of accounts" do
        @r.accounts["Assets"].should == {
          "AccountsReceivable" => {
            :name => "Assets:AccountsReceivable", :balance => {:amount => 0, :currency => nil},
          },
          "Current" => {
            "BestBank" => {
              "Checking" => {
                :name => "Assets:Current:BestBank:Checking", :balance => { :amount => 2206.56, :currency => "USD"},
              },
              :name => "Assets:Current:BestBank", :balance => {:amount => -8382.17,:currency => "USD"},
              "Savings" => {
                :name => "Assets:Current:BestBank:Savings", :balance => {:amount => -10588.73, :currency => "USD"}
              },
            },
            :name => "Assets:Current", :balance => { :amount => -9699.84, :currency => "USD"},
            "Cash" => {
              :name => "Assets:Current:Cash", :balance => {:amount => -1317.67, :currency => "USD"},
            }

          },
          "Investments" => {
            "UTrade" => {
              "Account" => {
                :name => "Assets:Investments:UTrade:Account", :balance => {:amount => 9980.78, :currency => "USD"},
                "AAPL" => {
                  :name => "Assets:Investments:UTrade:Account:AAPL", :balance => {:amount => 185.40, :currency => "USD" },
                },"EWJ" => {
                  :name => "Assets:Investments:UTrade:Account:EWJ", :balance => {:amount => 13.34, :currency => "USD"},
                }
              },
              :name => "Assets:Investments:UTrade", :balance => {:amount => 9980.78, :currency => "USD"}

            },
            :name => "Assets:Investments", :balance => {:amount => 9980.78, :currency => "USD"}

          },
          :name => "Assets", :balance => { :amount => 280.94,:currency => "USD"}

        }

        # "Equity" => {
        #     :name => "Equity", :balance => {:currency => "USD", :amount => -4407.06},
        #     "Opening-Balances" => {
        #       :name => "Equity:Opening-Balances", :balance => {:currency => "USD", :amount => -4407.06},
        #     }},
        #   "Expenses" => {
        #     :name => "Expenses", :balance => {:currency => "USD", :amount => 10647.66},
        #     "Books" => {
        #       :name => "Expenses:Books", :balance => {:currency => "USD", :amount => 74.43},
        #     },
        #     "Car" => {
        #       :name => "Expenses:Car", :balance => {:currency => "USD", :amount => 40.00},
        #       "Gas" => {
        #         :name => "Expenses:Car:Gas", :balance => {:currency => "USD", :amount => 40.00},
        #       }
        #     },
        #     "Charity" => {
        #         :name => "Expenses:Charity", :balance => {:currency => "USD", :amount => 50.00},
        #     },
        #     "Clothes" => {
        #         :name => "Expenses:Clothes", :balance => {:currency => "USD", :amount => 161.22},
        #     },
        #     "Communications" => {
        #       :name => "Expenses:Communications", :balance => {:currency => "USD", :amount => 126.39},
        #       "Mail" => {
        #         :name => "Expenses:Communications:Mail", :balance => {:currency => "USD", :amount => 4.43},
        #       },
        #       "Phone" => {
        #         :name => "Expenses:Communications:Phone", :balance => {:currency => "USD", :amount => 121.96},
        #       },
        #     },
        #     "Financial" => {
        #         :name => "Expenses:Financial", :balance => {:currency => "USD", :amount => 28.40},
        #       "Commissions" => {
        #         :name => "Expenses:Financial:Commissions", :balance => {:currency => "USD", :amount => 19.90},
        #       },
        #       "Fees" => {
        #         :name => "Expenses:Financial:Fees", :balance => {:currency => "USD", :amount => 8.50},
        #       }
        #     },
        #     "Food" => {
        #         :name => "Expenses:Food", :balance => {:currency => "USD", :amount => 2625.76},
        #       "Alcool" => {
        #         :name => "Expenses:Food:Alcool", :balance => {:currency => "USD", :amount => 600.00},
        #       },
        #       "Grocery" => {
        #         :name => "Expenses:Food:Grocery", :balance => {:currency => "USD", :amount => 54.03},
        #       },
        #       "Restaurant" => {
        #         :name => "Expenses:Food:Restaurant", :balance => {:currency => "USD", :amount => 1971.73},
        #       }
        #     },
        #     "Fun" => {
        #       :name => "Expenses:Fun", :balance => {:currency => "USD", :amount => 24.00},
        #       "Movie" => {
        #       :name => "Expenses:Fun:Movie", :balance => {:currency => "USD", :amount => 24.00},
        #       },
        #     },
        #     "Govt-Services" => {
        #       :name => "Expenses:Govt-Services", :balance => {:currency => "USD", :amount => 110.00},
        #     },
        #     "Home" => {
        #       :name => "Expenses:Home", :balance => {:currency => "USD", :amount => 2459.78},
        #       "Monthly" => {
        #         :name => "Expenses:Home:Monthly", :balance => {:currency => "USD", :amount => 2459.78},
        #         "Condo-Fees" => {
        #           :name => "Expenses:Home:Monthly:Condo-Fees", :balance => {:currency => "USD", :amount => 699.08},
        #         },
        #         "Loan-Interest" => {
        #           :name => "Expenses:Home:Monthly:Loan-Interest", :balance => {:currency => "USD", :amount => 1760.70},
        #         },
        #       }
        #     },
        #     "Insurance" => {
        #       :name => "Expenses:Insurance", :balance => {:currency => "USD", :amount => 4492.44},
        #       "Life" => {
        #         :name => "Expenses:Insurance:Life", :balance => {:currency => "USD", :amount => 4492.44},
        #       }
        #     },
        #     "Medical" => {
        #       :name => "Expenses:Medical", :balance => {:currency => "USD", :amount => 312.00},
        #     },
        #     "Sports" => {
        #       :name => "Expenses:Sports", :balance => {:currency => "USD", :amount => 209.00},
        #       "Gear" => {
        #       :name => "Expenses:Sports:Gear", :balance => {:currency => "USD", :amount => 89.00},
        #       }
        #     },
        #     "Taxes" => {
        #       :name => "Expenses:Taxes", :balance => {:currency => "USD", :amount => -77.76},
        #       "US-Federal" => {
        #         :name => "Expenses:Taxes:US-Federal", :balance => {:currency => "USD", :amount => -77.76},
        #       }
        #     },
        #     "Transportation" => {
        #       :name => "Expenses:Transportation", :balance => {:currency => "USD", :amount => 12.00},
        #       "Taxi" => {
        #         :name => "Expenses:Transportation:Taxi", :balance => {:currency => "USD", :amount => 12.00},}
        #     }
        #   },
        #   "Income" => {
        #       :name => "Income", :balance => {:currency => "USD", :amount => -8198.73},
        #     "Investments" => {
        #       :name => "Income:Investments", :balance => {:currency => "USD", :amount => -198.73},
        #       "Dividends" => {
        #         :name => "Income:Investments:Divdends", :balance => {:currency => "USD", :amount => -0.68},
        #       },
        #       "Interest" => {
        #         :name => "Income:Interest", :balance => {:currency => "USD", :amount => -198.05},
        #         "Checking" => {
        #           :name => "Income:Interest:Checking", :balance => {:currency => "USD", :amount => -0.02},
        #         },
        #         "Savings" => {
        #           :name => "Income:Interest:Savings", :balance => {:currency => "USD", :amount => -198.03},
        #         }
        #       }
        #     },
        #     "Salary" => {
        #       :name => "Income:Salary", :balance => {:currency => "USD", :amount => -8000.00},
        #       "AcmeCo" => {
        #         :name => "Income:Salary:AcmeCo", :balance => {:currency => "USD", :amount => -8000.00},
        #       }
        #     }
        #   },
        @r.accounts["Liabilities"].should  == {
          :name => "Liabilities", :balance => {:currency => "USD", :amount => 1677.19},
          "BestBank" => {
            :name => "Liabilities:BestBank", :balance => {:currency => "USD", :amount => 1026.06},
            "Mortgage" => {
              :name => "Liabilities:BestBank:Mortgage", :balance => {:currency => "USD", :amount => 1026.06},
              "Loan" => {
                :name => "Liabilities:BestBank:Mortgage:Loan", :balance => {:currency => "USD", :amount => 1026.06},
              }
            }
          },
          "Condo-Management" => {
            :name => "Liabilities:Condo-Management", :balance => {:currency => "USD", :amount => 100.92},
          },
          "Credit-Card" => {
            :name => "Liabilities:Credit-Card", :balance => {:currency => "USD", :amount => 550.21},
            "VISA" => {
              :name => "Liabilities:Credit-Card:VISA", :balance => {:currency => "USD", :amount => 550.21},
            }
          }
        }
      end

      it "should give correct names" do
        @r.accounts["Liabilities"]["Credit-Card"]["VISA"][:name].should == "Liabilities:Credit-Card:VISA"
      end

      it "should give correct balance" do
        @r.accounts["Liabilities"]["Credit-Card"]["VISA"][:balance].should == {:amount => 550.21, :currency => "USD"}
      end

      describe "balance" do
        it "should give correct balance" do
          @r.balance("Liabilities:Credit-Card:VISA").should == {:amount => 550.21, :currency => "USD"}
        end
      end

    end
  end



  describe "private functions" do
    before :all do
      @r = Rodger.new
    end

    it "should recurse accounts properly" do
      @r.send(:recurse_accounts,["a","b","c","d"]).should == {
        "a" =>
        {
          :name => "a",
          :balance => {
            :amount => 0,
            :currency => nil,
          },
          "b" =>
          {
            :name => "a:b",
            :balance => {
              :amount => 0,
              :currency => nil
            },
            "c" =>
            {
              :name => "a:b:c",
              :balance => {
                :amount => 0,
                :currency => nil
              },
              "d" => {
                :name => "a:b:c:d",
                :balance => {
                  :amount => 0, :currency => nil
                }
              }
            }
          }
        }
      }
    end
  end
end

describe AccountTree do
  describe "initialize" do
    before :all do
      @a = AccountTree.new(:a => {:b => {:c => 2}})
    end
    it "should return correct values" do
      @a[:a].should == {:b => {:c => 2}}
    end
  end

  describe "deep merge" do
    let(:x) { AccountTree.new(:a => {:b => 1, :d => 3}) }
    let(:y) { AccountTree.new(:a => {:c => 1, :d => 4}) }
    it "should deep merge properly" do
      x.deep_merge(y).should == {:a => {:b => 1, :c => 1, :d => 4}}
    end
  end



  it "should have a name on each node" do
    @a = AccountTree.new(:a => AccountTree.new({:name => "abc", :b => {:c => AccountTree.new({:a => 2, :name => "def"})}}))
    @a[:a][:name].should == "abc"
    @a[:a][:b][:c][:name].should == "def"
  end

  it "should recognise leaf accounts properly" do
    AT = AccountTree
    @a = AccountTree.new(:a => AT.new({:b => AT.new({:c => AT.new({})})}))
    @a[:a].leaf?.should == false
    @a[:a][:b].leaf?.should == false
    @a[:a][:b][:c].leaf?.should == true
  end

end
