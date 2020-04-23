module Error::Helpers
  class Render
    def self.json(messages)
      { errors: [messages] }.as_json
    end
  end
end