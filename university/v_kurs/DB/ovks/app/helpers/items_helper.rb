module ItemsHelper
  def model_to_sym obj
    obj.class.name.downcase.to_sym
  end
end
