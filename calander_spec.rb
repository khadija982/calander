# frozen_string_literal: true

require './lib/calander'

obj = Model.new

describe do
  it 'return true' do
    expect(obj.send(:validate_date_format, '12-12-2021')).to eq true
  end

  it 'Date must be greater than or euqal to current date' do
    expect(obj.send(:validate_date_format, '1-1-2021')).to eq false
  end

  it 'return true' do
    expect(obj.send(:validate_date_format, '1-1-2022')).to eq true
  end
end

describe do
  it 'return true' do
    expect(obj.send(:validate_time_format, '1:0:0')).to eq true
  end

  it 'Invalid date format' do
    expect(obj.send(:validate_time_format, '2:6:9:0')).to eq false
  end

  it 'Invalid date format' do
    expect(obj.send(:validate_time_format, '2:80:7')).to eq false
  end
end


describe do
  it 'return true' do
    expect(obj.send(:validate_end_time, '01:00:01:AM', '02:00:01:AM')).to eq true
  end

  it 'End time must be greater than start time' do
    expect(obj.send(:validate_end_time, '02:00:01:AM', '01:00:01:AM')).to eq false
  end

  it 'return true' do
    expect(obj.send(:validate_end_time, '10:00:00:AM', '12:00:01:PM')).to eq true
  end
end

describe do
  it 'return true' do
    expect(obj.send(:validate_mon, '8')).to eq true
  end

  it 'Invalid month' do
    expect(obj.send(:validate_mon, '24')).to eq false
  end

  it 'Invalid month' do
    expect(obj.send(:validate_mon, 'm')).to eq false
  end
end

describe do
  it 'return true' do
    expect(obj.send(:validate_year, '2021')).to eq true
  end

  it 'error invalid year' do
    expect(obj.send(:validate_year, '001')).to eq false
  end

  it 'error invalid year' do
    expect(obj.send(:validate_year, '10')).to eq false
  end
end

