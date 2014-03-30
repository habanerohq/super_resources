class SuperResources::NestResource

  attr_reader :name, :id, :klass, :model

  def initialize(name, id, klass, model)
    @name = name
    @id = id
    @klass = klass
    @model = model
  end

  def resource
    target_class.find(id)
  end

  protected

  def target_class
    name_match ||
    class_name_guess ||
    namespace_guess ||
    superclass_name_guess ||
    polymorphic_guess
  end

  def name_match
    reflection_class(klass.reflections[name])
  end

  def class_name_guess
    reflection_class(
      reflections.detect { |r| name.to_s.in?(r.class_name.underscore) }
    )
  end

  def namespace_guess
    (klass.name.underscore.split('/')[0 .. -2] << name).join('/').classify.safe_constantize
  end

  def superclass_name_guess
    reflection_class(
      reflections.detect { |r| name.to_s.include?(r.class_name.underscore.split('/').last) }
    )
  end

  def polymorphic_guess
    reflection_class(
      if model.present?
        reflections.detect do |r|
          n = model.send(r.name)
          name.to_s.in?(n.class.name.underscore)
        end
      end
    )
  end

  def reflection_class(reflection)
    reflection.class_name.safe_constantize if reflection.present?
  end

  def reflections
    @reflections ||= klass.reflections.values.select { |r| r.macro == :belongs_to }
  end
end
