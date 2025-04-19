class ErrorSerializer
  def self.serialize(error)
    {
      "message": "your query could not be completed",
      "errors": [error.message]
    }
  end
end