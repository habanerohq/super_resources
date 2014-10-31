module SuperResources
  module URLHelpers
    extend ActiveSupport::Concern

    included do
      helpers = %w(collection resource new_resource edit_resource parent)
      helper_methods = helpers.map do |helper|
        [ :"#{helper}_path", :"#{helper}_url" ]
      end

      helper_method(*(helper_methods.flatten))
    end

    protected

    # collection route helpers .................................................

    def collection_url
      super_url(with_nesting(resource_class))
    end

    def collection_path
      super_path(with_nesting(resource_class))
    end

    # resource route helpers ...................................................

    def resource_path(*args)
      options = args.extract_options!
      super_path(with_nesting(args.first || resource), options)
    end

    def resource_url(*args)
      options = args.extract_options!
      super_url(with_nesting(args.first || resource), options)
    end

    # new resource route helpers ...............................................

    def new_resource_path(options={})
      options.merge! :action => :new
      super_path(with_nesting(resource_class), options)
    end

    def new_resource_url(options={})
      options.merge! :action => :new
      super_url(with_nesting(resource_class), options)
    end

    # edit resource route helpers ..............................................

    def edit_resource_path(*args)
      options = args.extract_options!
      options.merge! :action => :edit

      super_path(with_nesting(args.first || resource), options)
    end

    def edit_resource_url(*args)
      options = args.extract_options!
      options.merge! :action => :edit

      super_url(with_nesting(args.first || resource), options)
    end

    # parent path helpers ......................................................

    def parent_path(options={})
      super_path(nests, options)
    end

    def parent_url(options={})
      super_path(nests, options)
    end

    # core stuff ..............................................................

    def super_path(chain, options={})
      super_url(chain, options.merge(:routing_type => :path))
    end

    def super_url(chain, options={})
      polymorphic_url(chain, options)
    end
  end
end
