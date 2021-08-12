# frozen_string_literal: true

require './lib/events'
# spec/events.rb

 obj = Events.new

describe do
  it 'return true' do
    expect(obj.send(:validate_date?, Date.parse('12-12-2021'))).to eq true
  end

  it 'return false' do
    expect(obj.send(:validate_date?, Date.parse('1-1-2021'))).to eq false
  end

  it 'return true' do
    expect(obj.send(:validate_date?, Date.parse('1-1-2022'))).to eq true
  end
end


describe do
  it 'return true' do
    expect(obj.send(:validate_time?, [1, 2, 3])).to eq true
  end

  it 'return false' do
    expect(obj.send(:validate_time?, [2, 3, 4, 5])).to eq false
  end

  it 'return true' do
    expect(obj.send(:validate_time?, [1, 0, 0])).to eq true
  end
end


describe do
  it 'return true' do
    expect(obj.send(:set_time, Date.parse('12-12-2021'), [1, 0, 0])).eql? "01:00:01:AM"
  end

  it 'return error' do
    expect(obj.send(:set_time, Date.parse('12-12-2021'), [1, 0])).eql? "error"
  end

  it 'return error' do
    expect(obj.send(:set_time, Date.parse('1-9-2021'), [1,])).eql? "error"
  end
end