require 'shopping_cart'

RSpec.describe ShoppingCart do
  let(:path) { Pathname.new(__FILE__) }
  let(:dir) { path.dirname }
  let(:fixtures) { dir.join('fixtures') }
  RSpec.shared_examples "shopping cart" do |input_filename, output_filename|
    let(:given_input) { fixtures.join(input_filename) }
    let(:expected_output) { fixtures.join(output_filename).read }
    let(:cart) { described_class.new }
    it "given input should generate output" do
      cart.read(given_input)
      puts "Cart"
      cart.items.each do |item|
        puts item.inspect
      end
      expect do 
        cart.write
      end.to output(expected_output).to_stdout
    end
  end
  it_behaves_like 'shopping cart', 'input1.txt', 'output1.txt'
  it_behaves_like 'shopping cart', 'input2.txt', 'output2.txt'
  it_behaves_like 'shopping cart', 'input3.txt', 'output3.txt'
end
