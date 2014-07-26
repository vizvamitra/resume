class String
  def trim
    self.gsub(/([^[:word:]\s\d-])/){'\\'+$1}
  end
end