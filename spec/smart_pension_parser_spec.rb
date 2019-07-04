RSpec.describe SmartPensionParser do
  let(:logpath) { 'webserver.log' }
  subject { described_class.new(logpath) }

  describe 'initialized without the logfile' do
    let(:logpath) { 'randon_location.log' }
    it 'raise an error', :skip_before do
      expect { subject }.to
        raise_error(RuntimeError, "Log file doesn't exist at location #{logpath}")
    end
  end

  describe '#parse_log' do
    before { subject.parse_log }

    let(:expectation) do
      {
        '/help_page/1'   => ['126.318.035.038', '646.865.545.408', '646.865.545.408'],
        '/contact' => ['184.123.665.067','555.576.836.194'],
        '/home'   => ['184.123.665.067','235.313.352.950','316.433.849.805'],
        '/about/2' => ['444.701.448.104','444.701.448.104'],
        '/about'    => ['836.973.694.403', '235.313.352.950','235.313.352.950']
      }
    end

    it "parses the data" do
      expect(subject.logs).to eq(expectation)
    end
  end

#================ Testing unique page views =====================
 describe '#unique_page_views' do
    before { subject.parse }
    let(:expected_results) do
      {
        '/help_page/1'    => 2,
        '/contact'   => 2,
        '/home'   => 3,
        '/about/2' => 1,
        '/about' => 2
      }
    end

    it 'returns the unique page views' do
      expect(subject.unique_page_views).to eq(expected_results)
    end
  end

  #================ Testing total views =====================
  describe '#total_views' do
    before { subject.parse_log }

    let(:expected_results) do
      {
        '/help_page/1'   => 3,
        '/contact'    => 2,
        '/home'   => 3,
        '/about/2' => 2,
        '/about' => 3
      }
    end

    it 'returns the total page views' do
      expect(subject.total_views).to eq(expected_results)
    end
  end
end
