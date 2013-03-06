module SuperResources
  module URLHelpers
    extend ActiveSupport::Concern

    included do
      helpers = %w(collection resource new_resource edit_resource)

      helpers.each do |helper|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{helper}_path(*args)
            url_for(hash_for_#{helper}_path(*args))
          end

          def #{helper}_url(*args)
            url_for(hash_for_#{helper}_url(*args))
          end

          def hash_for_#{helper}_path(*args)
            hash_for_#{helper}_url(*args).merge(:only_path => true)
          end
        RUBY_EVAL
      end

      helper_methods = helpers.map do |helper|
        [ :"#{helper}_path", :"hash_for_#{helper}_path",
          :"#{helper}_url", :"hash_for_#{helper}_url" ]
      end

      helper_method(*(helper_methods.flatten))
    end

    protected

    # core stuff ..............................................................

    def route_hash
      path_parameters.except(:id, :action)
    end

    # route helpers ...........................................................

    def hash_for_collection_url(options={})
      route_hash.merge(options).merge(:action => 'index')
    end

    def hash_for_resource_url(*args)
      options = args.extract_options!
      route_hash.merge(options)
                .merge(:action => 'show', :id => args.first || resource)
    end

    def hash_for_new_resource_url(options={})
      route_hash.merge(options).merge(:action => 'new')
    end

    def hash_for_edit_resource_url(*args)
      options = args.extract_options!
      route_hash.merge(options)
                .merge(:action => 'edit', :id => args.first || resource)
    end
  end
  
end
