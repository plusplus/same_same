require 'same_same'

describe SameSame::SymmetricalMatrix do

  describe "#lookup" do
    
    context "with no lookup" do
      subject {SameSame::SymmetricalMatrix.new(5)}

      it "is nil for unspecified elements" do
        expect( subject.lookup(1,2) ).to be_nil
      end

      it "returns a set value" do
        subject.set(1,2,"value")
        expect( subject.lookup(1,2) ).to eq("value")
      end

      it "returns the inverse of a set value" do
        subject.set(1,2,"value")
        expect( subject.lookup(2,1) ).to eq("value")
      end

      it "raises argument error for out of bounds parameters" do
        expect { subject.lookup(5,1)  }.to raise_error( ArgumentError)
        expect { subject.lookup(1,5)  }.to raise_error( ArgumentError)
        expect { subject.lookup(-1,1) }.to raise_error( ArgumentError)
        expect { subject.lookup(1,-1) }.to raise_error( ArgumentError)
      end
   
      it "uses blocks to calulate missing values" do
        expect( subject.lookup(1,2) {|x,y| "#{x}-#{y}"} ).to eq("1-2")
      end

      it "ignores blocks when value set" do
        subject.set(1,2,"value")
        expect( subject.lookup(1,2) {|x,y| "#{x}-#{y}"} ).to eq("value")
      end

    end

    context "with a lookup proc" do
      let( :proc ) {double("proc")}
      subject {SameSame::SymmetricalMatrix.new(5, proc)}

      it "is calculated for unspecified elements" do
        proc.should_receive( :call ).with(1,2).and_return "1-2"
        expect( subject.lookup(1,2) ).to eq("1-2")
      end

      it "is only calls the proc once" do
        proc.should_receive( :call ).with(1,2).and_return "1-2"
        expect( subject.lookup(1,2) ).to eq("1-2")
        expect( subject.lookup(1,2) ).to eq("1-2")
      end

      it "is only calls the proc once if the inverse is looked up" do
        proc.should_receive( :call ).with(1,2).and_return "1-2"
        expect( subject.lookup(1,2) ).to eq("1-2")
        expect( subject.lookup(2,1) ).to eq("1-2")
      end

      it "is prefers set values to the lookup" do
        subject.set(1,2,"value")
        expect( subject.lookup(1,2) ).to eq("value")
      end
    end
  end
end