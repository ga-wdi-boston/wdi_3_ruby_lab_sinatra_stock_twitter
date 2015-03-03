require 'stock_quote'
require 'pry'

def stock_symbol(sym)
	stock = StockQuote::Stock.quote(sym)
	p stock.last
	p stock.company
	stock_history = StockQuote::Stock.history(sym)
end

stock_symbol("goog")