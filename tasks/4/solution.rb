describe Version do
  describe '#components' do
    it 'returns the numbers' do
      expect(Version.new('1.3.5').components).to eq [1, 3, 5]
    end
    
    it 'can return fewer numbers' do
      expect(Version.new('1.8.8.5').components(2)).to eq [1, 8]
    end
    
    it 'adds zeros' do
      expect(Version.new('7.1.8').components(5)).to eq [7, 1, 8, 0, 0]
    end  
  end
  
  describe '#<=>' do
    it 'ignores zeros at the end' do
      expect(Version.new('6.8.1.0.0') <=> Version.new('6.8.1')).to be 0
    end
    
    it 'compares first pair of different numbers' do
      expect(Version.new('1.9.7.1') <=> Version.new('1.9.8.1')).to be -1
    end
    
    it 'adds zeros' do
      expect(Version.new('1.9.9.6') <=> Version.new('1.9.9')).to be 1
    end
  end
  
  describe '#to_s' do
    it 'converts to string' do
      expect(Version.new('9.1.7').to_s).to eq '9.1.7'
    end
    
    it 'ignores zeros at the end' do
      expect(Version.new('9.1.7.0.0').to_s).to eq '9.1.7'
    end
  end
end