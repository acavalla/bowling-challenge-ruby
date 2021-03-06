# frozen_string_literal: true

require 'game'

describe Game do

  it 'initializes with an empty frames array' do
    expect(subject.frames).to eq []
  end

  describe '#input_bowl' do
    context 'first 1-9 rolls' do
      it 'takes one argument; saves it to score' do
        expect(subject).to respond_to(:input_bowl).with(1).argument
      end

      it 'saves pins and adds to score' do
        subject.input_bowl(2)
        subject.input_bowl(5)
        expect(subject.score).to eq 7
      end

      it 'makes a second frame on third roll' do
        subject.input_bowl(2)
        subject.input_bowl(5)
        subject.input_bowl(5)
        expect(subject.frames.length).to eq 2
      end

      it 'closes frame after strike and opens new frame on next roll' do
        subject.input_bowl(10)
        subject.input_bowl(5)
        expect(subject.frames.length).to eq 2
      end
    end
  end

  context 'final roll' do
    it 'allows third roll if strike' do
      18.times { subject.input_bowl(2) }
      subject.input_bowl(10)
      expect(subject.frames.length).to eq 10
      subject.input_bowl(10)
      subject.input_bowl(10)
      expect(subject.frames[-1].rolls.length).to eq 3
    end
  end

  context 'end of game' do
    it 'says game over and prevents more bowls' do
      20.times { subject.input_bowl(2) }
      expect {subject.input_bowl(2) }.to raise_error "Game over"
    end
  end

  context 'bonus' do
    it 'opens a Bonus class if strike' do
      subject.input_bowl(10)
      subject.input_bowl(2)
      expect(subject.bonuses.length).to eq 1
      expect(subject.bonuses[-1]).to be_a Bonus
    end

    it 'opens a Bonus class if spare' do
      subject.input_bowl(8)
      subject.input_bowl(2)
      subject.input_bowl(2)
      expect(subject.bonuses.length).to eq 1
    end

    it 'adds bonus scores to running total' do
      subject.input_bowl(8)
      subject.input_bowl(2)
      subject.input_bowl(4)
      expect(subject.score).to eq 18
    end

    it 'doesnt open bonuses for frame 10 rolls 2 & 3' do
      12.times { subject.input_bowl(10) }
      expect(subject.bonuses.length).to eq 10
    end
  end

  describe 'return messages' do
    it 'creates an instance of the message class' do
      expect(subject.input_bowl(8)).to eq "You rolled 8!"
      expect(subject.messages.length).to eq 1
    end
  end
end
