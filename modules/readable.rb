require 'csv'

module Readable
  def file(location)
    rows = CSV.read(location, headers: true)
    rows.map  {|row| new(row)}
  end
end
