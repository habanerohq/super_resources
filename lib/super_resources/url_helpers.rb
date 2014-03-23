module SuperResources
  module URLHelpers
    extend ActiveSupport::Concern

    included do
      helpers = %w(collection resource new_resource edit_resource parent)
      helper_methods = helpers.map do |helper|
        [ :"#{helper}_path", :"hash_for_#{helper}_path",
          :"#{helper}_url", :"hash_for_#{helper}_url" ]
      end

      helper_method(*(helper_methods.flatten))

      helper_method :module_name_hierarchy
    end

    protected

    # core stuff ..............................................................

    def route_hash
      path_parameters.except(:id, :action)
    end

    def super_path(chain, options={})
      super_url(chain, options.merge(:routing_type => :path))
    end

    def super_url(chain, options={})
      #polymorphic_url(qualified_chain(chain), options)
      polymorphic_url(chain, options)
    rescue NoMethodError => e
      object = chain.pop

      chain.empty? ? raise(e) : super_path(chain.slice(0...-1) << object, options)
    end

    # collection route helpers .................................................

    def collection_url
      super_url(with_chain(resource_class))
    end

    def collection_path
      super_path(with_chain(resource_class))
    end

    def hash_for_collection_url(options={})
      route_hash.merge(options).merge(:action => 'index')
    end

    # resource route helpers ...................................................

    def resource_path(*args)
      options = args.extract_options!
      super_path(with_chain(args.first || resource), options)
    end

    def resource_url(*args)
      options = args.extract_options!
      super_url(with_chain(args.first || resource), options)
    end

    def hash_for_resource_url(*args)
      options = args.extract_options!
      route_hash.merge(options)
                .merge(:action => 'show', :id => args.first || resource)
    end

    # new resource route helpers ...............................................

    def new_resource_path(options={})
      options.merge! :action => :new
      super_path(with_chain(resource_class), options)
    end

    def new_resource_url(options={})
      options.merge! :action => :new
      super_url(with_chain(resource_class), options)
    end

    def hash_for_new_resource_url(options={})
      route_hash.merge(options).merge(:action => 'new')
    end

    # edit resource route helpers ..............................................

    def edit_resource_path(*args)
      options = args.extract_options!
      options.merge! :action => :edit

      super_path(with_chain(args.first || resource), options)
    end

    def edit_resource_url(*args)
      options = args.extract_options!
      options.merge! :action => :edit

      super_url(with_chain(args.first || resource), options)
    end

    def hash_for_edit_resource_url(*args)
      options = args.extract_options!
      route_hash.merge(options)
                .merge(:action => 'edit', :id => args.first || resource)
    end

    # parent path helpers ......................................................

    def parent_path(options={})
      super_path(association_chain, options)
    end

    def parent_url(options={})
      super_path(association_chain, options)
    end

    def hash_for_parent_path(options={})
      # TODO: mess around with this sucker
      raise NotImplementedException
    end

    # module qualification helpers .............................................

    def qualified_chain(chain)
      (module_name_hierarchy + chain).compact
    end

    def module_name_hierarchy
      self.class.name.split('::')[0 .. -2].map(&:underscore)
    end
  end
end
