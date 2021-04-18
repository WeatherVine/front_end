class Wine
attr_reader :api_id,
            :name,
            :comment

  def initialize(data)
    @api_id = data[:api_id]
    @name = data[:name]
    @comment = data[:comment]
  end

end
