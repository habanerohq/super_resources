module SuperResources
  class Railtie < Rails::Railtie
    if config.respond_to?(:app_generators)
      config.app_generators.scaffold_controller = :super_controller
    else
      config.generators.scaffold_controller = :super_controller
    end
  end
end
