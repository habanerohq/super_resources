module SuperResources
  module URLHelpers
    extend ActiveSupport::Concern

    included do
      helpers = %w(collection resource new_resource edit_resource)
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

    def super_path(chain, options={})
      polymorphic_url(chain, options)
    rescue NoMethodError => e
      object = chain.pop

      chain.empty? ?
        raise(e) : super_path(chain.slice(0...-1) << object, options)
    end

    def super_url(chain, options={})
      super_path(chain, options.merge(:routing_type => :url))
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
  end
end
