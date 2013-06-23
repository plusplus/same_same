require 'samesame'

describe SameSame::MergeGoodnessMeasure do

  context "0 proximity (all are neighbours)" do
    subject {SameSame::MergeGoodnessMeasure.new(0.0)}

    describe '#g' do
      it "should do something I'm not quite sure of" do
        # these 'specs' aren't specs - I'm not quite in a position
        # to write anything specific here. Just really ensuring that
        # the methods don't fail
        expect( subject.g( 10, 10, 10 ) ).to eq(0.0016666666666666668)
        expect( subject.g( 2, 10, 10 ) ).to  eq(0.0003333333333333333)
      end
    end
  end

  context "1.0 proximity (no neighbours)" do
    subject {SameSame::MergeGoodnessMeasure.new(1.0)}

    describe '#g' do
      it "should always return infinity" do
        # note to self: this makes sense. If no datapoints are
        # considered neighbours the goodness for any cluster will
        # infinite (where infinite means bad). Why isn't it called
        # a BADNESS measure then?
        expect( subject.g( 10, 10, 10 ) ).to eq(Float::INFINITY)
        expect( subject.g( 2, 10, 10 ) ).to eq(Float::INFINITY)
      end
    end
  end

end