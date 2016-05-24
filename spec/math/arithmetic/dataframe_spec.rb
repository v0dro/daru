describe Daru::DataFrame do
  before(:each) do
    @df = Daru::DataFrame.new({a: [1,2,3,4,5], b: ['a','e','i','o','u'],
      c: [10,20,30,40,50]})
    @left = Daru::DataFrame.new({a: [1,nil,nil,4], b: [10,nil,nil,40], c: [5,6,7,8]},
      index: [0,4,5,3])
    @right = Daru::DataFrame.new({a: [1,2,3,4,5], b: [10,20,30,40,50]},
      index: [0,1,2,3,6])
  end

  context "#+" do
    it "adds a number to all numeric vectors" do
      expect(@df + 2).to eq(Daru::DataFrame.new({a: [3,4,5,6,7], b: ['a','e','i','o','u'],
      c: [12,22,32,42,52] }))
    end

    it "adds two dataframes to produce a third" do
      expect(@left + @right).to eq(Daru::DataFrame.new({
        a: [2,nil,nil,8,nil,nil],
        b: [20,nil,nil,80,nil,nil],
        c: [nil,nil,nil,nil,nil,nil]
        }, index: [0,1,2,3,4,5,6]))
    end
  end

  context "#-" do
    it "subtracts a number from all numeric vectors" do
      expect(@df - 2).to eq(Daru::DataFrame.new({
        a: [-1,0,1,2,3],
        b: ['a','e','i','o','u'],
        c: [8,18,28,38,48]}))
    end

    it "subtracts a data frame from another" do

    end
  end

  context "#*" do
    it "multiplies a number with a DataFrame" do
    end
  end

  context "#/" do

  end

  context "#%" do

  end

  context "#**" do

  end

  context "#sqrt" do
    it "calculates sqrt" do
      expect_correct_df_in_delta(@df.sqrt,
        Daru::DataFrame.new({
          a: [1.0,1.41421356,1.73205080,2.0,2.23606797],
          c: [3.16227766, 4.47213595 ,5.47722557 ,6.32455532, 7.07106781]
        }), 0.001
      )
    end
  end

  context "#round", focus: true do
    it "rounds to precision" do
      df = Daru::DataFrame.new({
        a: [1.3434,2.4332,5.6655,12.3344,32.233],
        b: [1.3434,2.4332,5.6655,12.3344,32.233],
        c: %w(a b c d e)
      })
      ans = Daru::DataFrame.new({
        a: [1.34,2.43,5.67,12.33,32.23],
        b: [1.34,2.43,5.67,12.33,32.23],
      })

      expect(df.round(2)).to eq(ans)
    end
  end

  context "#exp" do
    it "calculates exponential" do
      @df.exp
    end
  end
end
